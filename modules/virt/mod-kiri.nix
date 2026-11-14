{
  flake.modules.nixos.kiri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.virtualisation.kiri;
      socket = "/run/kiri/docker.sock";

      # Another engine already serves /run/docker.sock through a socket unit:
      # linking Kiri's socket there would make that unit fail to bind.
      dockerSocketTaken =
        (config.virtualisation.docker.enable or false)
        || (config.virtualisation.podman.dockerSocket.enable or false);

      # Both put a `docker` on PATH: Docker its own CLI, podman (with
      # dockerCompat) a symlink to podman. Installing pkgs.docker-client too
      # would only make the winner of the collision arbitrary.
      dockerCliProvided =
        (config.virtualisation.docker.enable or false)
        || (config.virtualisation.podman.dockerCompat or false);
    in
    {
      options.virtualisation.kiri = {
        enable = lib.mkEnableOption "Kiri, a container engine that speaks the Docker Engine API";

        package = lib.mkPackageOption pkgs "kiri" { };

        users = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          example = [ "alice" ];
          description = ''
            Accounts allowed to reach the engine at ${socket}. They join the
            `kiri` group, whose members can run containers as root: treat it
            like the `docker` group. Being added takes a new login before the
            socket lets the account in.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        warnings =
          lib.optional (config.virtualisation.docker.enable or false) ''
            virtualisation.kiri and virtualisation.docker are both enabled. Their default
            bridges both want 172.17.0.0/16: Kiri moves to the next free subnet
            when it sees the host route, but Docker keeps its hardcoded default,
            so whichever engine starts second may fail to bring its bridge up.
            Disable one, or give Docker another bridge (for example
            virtualisation.docker.daemon.settings.bip = "172.20.0.1/16").
          ''
          ++ lib.optional (config.virtualisation.podman.dockerCompat or false) ''
            virtualisation.podman.dockerCompat makes `docker` an alias for podman.
            Kiri's docker passthrough commands (`kiri run`, `kiri compose`, ...)
            exec that `docker`, and podman ignores DOCKER_HOST, so they would act
            on podman instead of Kiri. Disable dockerCompat, or keep a real Docker
            CLI earlier on PATH.
          '';

        users.groups.kiri = { };

        users.users = lib.genAttrs cfg.users (user: {
          extraGroups = [ "kiri" ];
        });

        systemd.services.kiri = {
          description = "Kiri container engine";
          documentation = [ "https://runkiri.com" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];

          # The daemon keeps its state (its CA, proxy settings) in $HOME/.kiri.
          environment = {
            KIRI_SOCKET = socket;
            KIRI_SOCKET_GROUP = "kiri";
            HOME = "/var/lib/kiri-daemon";
          };

          # Tools that ignore docker contexts (docker-py, Go's client.FromEnv,
          # Testcontainers, IDE plugins) look for /run/docker.sock rather than
          # a context: link Kiri's socket there while nothing else owns the
          # path, and take the link away again when Kiri stops. Leave the path
          # to docker or podman when one of them serves it.
          postStart = lib.mkIf (!dockerSocketTaken) ''
            if [ ! -e /run/docker.sock ] && [ ! -L /run/docker.sock ]; then
              ln -s ${socket} /run/docker.sock
            fi
          '';
          postStop = lib.mkIf (!dockerSocketTaken) ''
            if [ "$(readlink /run/docker.sock)" = ${socket} ]; then
              rm -f /run/docker.sock
            fi
          '';

          serviceConfig = {
            ExecStart = "${lib.getExe cfg.package} daemon";
            # The daemon creates the cgroups its containers run in.
            Delegate = true;
            KillMode = "mixed";
            Restart = "on-failure";
            RuntimeDirectory = "kiri";
            # 0755: members of kiri reach the socket (itself 0660 root:kiri)
            # through it.
            RuntimeDirectoryMode = "0755";
            StateDirectory = "kiri-daemon";
            StateDirectoryMode = "0700";
            UMask = "0027";
          };
        };

        environment.systemPackages =
          [
            cfg.package
            # Kiri execs a `docker` client for its docker passthrough commands
            # (and the window checks for one); only the CLI, never the daemon.
            pkgs.docker-compose
            pkgs.docker-buildx
          ]
          # virtualisation.docker and podman's dockerCompat already provide
          # bin/docker; adding ours too would collide.
          ++ lib.optional (!dockerCliProvided) pkgs.docker-client;

        # The docker CLI looks for cli-plugins in /usr/libexec on other
        # distributions; point it at the store paths instead.
        environment.variables.DOCKER_CLI_PLUGIN_EXTRA_DIRS = lib.makeSearchPath "libexec/docker/cli-plugins" [
          pkgs.docker-compose
          pkgs.docker-buildx
        ];
      };
    };
}
