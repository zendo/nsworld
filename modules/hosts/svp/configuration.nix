{ inputs, config, ... }:
let
  userName = "zendo";
  hostName = "svp";
  fm = config.flake.modules;
in
{
  # nixos-rebuild --target-host root@svp --flake .#svp boot --install-bootloader
  # colmena apply --no-substitutes --on svp && ssh zendo@svp dix last
  flake.nixosConfigurations.svp = inputs.nixpkgs.lib.nixosSystem {
    modules = with fm.nixos; [
      host-svp
      host-svp-disko-btrfs
      hjemModule

      # [ profiles ]
      # gpu-intel
      server

      # [ core ]
      base
      boot
      ssh
      # gpg
      user

      mods
      selfhosted
      services

      # [ networking ]
      dns
      firewall
      # networkmanager
      # print
      samba

      # [ nix ]
      # nix-cache
      # nix-tools
      nixconfig
      nixpkgs

      # [ shell ]
      alias
      bash
      # fish
      zsh
      terminal

      # [ virt ]
      docker

      # [ xdg ]
      data-center
      env
      # mime
    ];
  };

  flake.modules.nixos.host-svp =
    { config, pkgs, ... }:
    {
      myVars.user = userName;
      networking.hostName = hostName;
      users.defaultUserShell = pkgs.zsh;

      services.logind.settings.Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
      };

      # Blank the console after 10 minutes of inactivity.
      boot.kernelParams = [ "consoleblank=600" ];

      boot.loader = {
        efi.efiSysMountPoint = "/efi";
        systemd-boot.enable = true;
      };

      zramSwap.enable = true;
      swapDevices = [
        {
          device = "/var/swapfile";
          size = 1024 * 8;
        }
      ];

      # [ selfhosted ]
      services.caddy.enable = true;
      # services.homepage-dashboard.enable = true;
      services.navidrome.enable = true;
      # services.dufs.enable = true;
      services.goshs.enable = true;
      # services.miniflux.enable = true; # wall
      services.memos.enable = true;
      services.rqbit.enable = true;
      # services.suwayomi-server.enable = true;
      # systemd.services.kula.enable = true;
      systemd.services.sub-store.enable = true;
      systemd.services.comigo.enable = true;
      systemd.services.dynacat.enable = true;
      services.beszel = {
        hub.enable = true;
        agent.enable = true;
        agent.environment = {
          KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKRs2TkpwEXDkq96tZ7uflRsQHu1OgZb8fL/vxxu+kRY";
        };
      };

    };
}
