{
  flake.modules.nixos.mods =
    {
      config,
      lib,
      pkgs,
      utils,
      ...
    }:
    let
      cfg = config.services.goshs;
      settingsFormat = pkgs.formats.json { };
      settingsFile = settingsFormat.generate "goshs.json" cfg.settings;
    in
    {
      options.services.goshs = {
        enable = lib.mkEnableOption "goshs file server";

        package = lib.mkPackageOption pkgs "goshs" { };

        user = lib.mkOption {
          type = lib.types.str;
          default = "goshs";
          description = "User account under which goshs runs.";
        };

        group = lib.mkOption {
          type = lib.types.str;
          default = "goshs";
          description = "Group under which goshs runs.";
        };

        openFirewall = lib.mkEnableOption "opening the goshs TCP port in the firewall";

        environmentFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/secrets/goshs.env";
          description = ''
            Environment file as defined in systemd.exec(5).
            Use it for sensitive environment variables supported by goshs.
          '';
        };

        settings = lib.mkOption {
          type = settingsFormat.type;
          default = { };
          example = {
            # Required
            interface = "0.0.0.0";
            port = 8000;
            directory = "/data";
            uploadFolder = "/data";
            # Optional
            auth = "";
            webdav = true;
            webdav_port = 8001;
            upload = true;
          };
          description = ''
            Configuration for goshs. See <https://docs.goshs.de/usage/config/index.html>
            for available options.

            The interface, port, directory, and upload_folder fields are required.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        users.users = lib.mkIf (cfg.user == "goshs") {
          goshs = {
            inherit (cfg) group;
            isSystemUser = true;
          };
        };

        users.groups = lib.mkIf (cfg.group == "goshs") {
          goshs = { };
        };

        networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.port ];

        systemd.services.goshs = {
          description = "goshs file server";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            ExecStart = utils.escapeSystemdExecArgs [
              (lib.getExe cfg.package)
              "-C"
              settingsFile
            ];

            Restart = "on-failure";
            User = cfg.user;
            Group = cfg.group;

            EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;

            ReadWritePaths = [ cfg.settings.uploadFolder ];
            UMask = "0077";

            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectSystem = "strict";
            DevicePolicy = "closed";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            RestrictAddressFamilies = [
              "AF_UNIX"
              "AF_INET"
              "AF_INET6"
              "AF_NETLINK"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
          };
        };
      };

      meta.maintainers = with lib.maintainers; [ zendo ];
    };
}
