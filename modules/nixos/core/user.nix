{
  flake.modules.nixos.host-yoga = { lib, config, ... }: {
    # No passwd on my main machine
    security.sudo.wheelNeedsPassword = false;
    security.sudo-rs.wheelNeedsPassword = false;
    security.run0.wheelNeedsPassword = lib.mkIf (config.security.run0.enable) false;
  };

  flake.modules.nixos.user =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options.myVars.user = lib.mkOption { type = lib.types.str; };

      config = {
        # Declaratively users and groups
        services.userborn.enable = lib.mkDefault true;

        # sudo-rs
        # security.sudo-rs.enable = true;

        # Only allow `wheel` group execute sudo
        security.sudo.execWheelOnly = true;
        security.sudo-rs.execWheelOnly = true;

        # run0
        security.sudo.enable = false;
        security.run0.enable = true;
        security.run0.enableSudoAlias = true;

        users = {
          mutableUsers = lib.mkDefault false;

          users.root = {
            # initialHashedPassword = "$y$j9T$ADp.JgagrVYSV4dPkJbKv/$INtu0eR/6.xYHzKlFmlTBWNFuAEkXnLMOU5hPYY8GM9";
            # copy ssh pub key to /etc/ssh/authorized_keys.d/root or ~/.ssh/authorized_keys
            # ssh-copy-id -i ~/.ssh/id_ed25519.pub aaa@192.168.122.85
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrQVhdLD9o1Iq17LKFNQ21PaHIAylizOFkvh74FUrz"
            ];
          };

          users.${config.myVars.user} = {
            isNormalUser = true;
            # shell = pkgs.fish;
            # `mkpasswd`
            initialHashedPassword = "$y$j9T$aNhZV153pAbvGMeFqjGmn.$iH18jxovF5Huof8U4NNPK/EVWHH75o5x8lRzq8IHZO3";
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrQVhdLD9o1Iq17LKFNQ21PaHIAylizOFkvh74FUrz"
            ];
            extraGroups = [
              "wheel"
              "networkmanager"
              "input"
              "video"
              "adbusers"
            ]
            ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]
            ++ lib.optionals config.virtualisation.podman.enable [ "podman" ]
            ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
            ++ lib.optionals config.virtualisation.incus.enable [ "incus-admin" ]
            ++ lib.optionals config.virtualisation.virtualbox.host.enable [ "vboxusers" ];
          };

          # users.guest = {
          #   isNormalUser = true;
          #   initialHashedPassword = "$y$j9T$oznNwtFAUKqaYFuvQPnA0/$Etrip7WsJhPV64kBsW61fO.MUgB50eEJeUpXCA48cxC";
          # };
        };

        # Allow non-root users use `--allow-other` in mounts
        programs.fuse.userAllowOther = true;
      };
    };
}
