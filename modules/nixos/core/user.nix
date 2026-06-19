{
  flake.modules.nixos.host-yoga = {
    # No passwd on my main machine
    security.sudo.wheelNeedsPassword = false;
    security.sudo-rs.wheelNeedsPassword = false;
    security.run0.wheelNeedsPassword = false;
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
        security.sudo-rs.enable = true;

        # run0
        # security.run0.enable = true;
        # security.run0.enableSudoAlias = true;

        # rule
        security.sudo.execWheelOnly = true;
        security.sudo-rs.execWheelOnly = true;

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
            shell = pkgs.fish;
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

            subUidRanges = [
              {
                startUid = 100000;
                count = 65536;
              }
            ];
            subGidRanges = [
              {
                startGid = 100000;
                count = 65536;
              }
            ];
          };

          # users.guest = {
          #   isNormalUser = true;
          #   initialHashedPassword = "$y$j9T$oznNwtFAUKqaYFuvQPnA0/$Etrip7WsJhPV64kBsW61fO.MUgB50eEJeUpXCA48cxC";
          # };
        };

        # Allow non-root users use `--allow-other` in mounts
        programs.fuse.userAllowOther = true;

        # Workaround for userborn: Generate subuid/subgid files from the user configuration
        # https://github.com/nikstur/userborn/issues/7
        system.activationScripts.podman-subid =
          let
            user = config.users.users.${config.myVars.user};
            subuidContent = lib.concatMapStrings (
              range: "${config.myVars.user}:${toString range.startUid}:${toString range.count}\n"
            ) user.subUidRanges;
            subgidContent = lib.concatMapStrings (
              range: "${config.myVars.user}:${toString range.startGid}:${toString range.count}\n"
            ) user.subGidRanges;
          in
          {
            text = ''
              if [ -L /etc/subuid ]; then rm /etc/subuid; fi
              if [ -L /etc/subgid ]; then rm /etc/subgid; fi
              cp -f ${pkgs.writeText "subuid" subuidContent} /etc/subuid
              cp -f ${pkgs.writeText "subgid" subgidContent} /etc/subgid
              chmod 644 /etc/subuid /etc/subgid
            '';
          };
      };
    };
}
