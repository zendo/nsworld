{
  flake.modules.nixos.user =
    { lib, config, ... }:
    {
      # Declaratively users and groups
      services.userborn.enable = lib.mkDefault true;

      # Vanilla sudo
      # Only allow `wheel` group execute sudo
      security.sudo.execWheelOnly = true;

      # sudo-rs
      # security.sudo-rs.enable = true;
      # security.sudo-rs.execWheelOnly = true;

      # run0
      security.sudo.enable = false;
      security.run0 = {
        enable = true;
        enableSudoAlias = true;
        persistentAuth.enable = true;
      };
      # system.tools.nixos-rebuild.enableRun0Elevation = true;

      users = {
        mutableUsers = lib.mkDefault false;

        users.root = {
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrQVhdLD9o1Iq17LKFNQ21PaHIAylizOFkvh74FUrz"
          ];
        };

        users.${config.myVars.user} = {
          isNormalUser = true;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrQVhdLD9o1Iq17LKFNQ21PaHIAylizOFkvh74FUrz"
          ];
          extraGroups = [
            "wheel"
            "networkmanager"
            "input"
            "video"
          ]
          # [ selfhosted ]
          ++ lib.optionals config.services.samba.enable [ "samba" ]
          # [ virt ]
          ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]
          ++ lib.optionals config.virtualisation.podman.enable [ "podman" ]
          ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
          ++ lib.optionals config.virtualisation.incus.enable [ "incus-admin" ]
          ++ lib.optionals config.virtualisation.virtualbox.host.enable [ "vboxusers" ]
          # [ ... ]
          ++ lib.optionals config.services.keyd.enable [ "keyd" ];
        };
      };

      # Allow non-root users use `--allow-other` in mounts
      programs.fuse.userAllowOther = true;
    };
}
