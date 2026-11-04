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

      # [ profiles ]
      # gpu-intel
      server

      # [ core ]
      base
      boot
      ssh
      ssh-hosts
      # gpg
      user

      mods
      selfhosted
      services

      # [ networking ]
      dns
      avahi
      firewall
      samba
      # tailscale

      # [ nix ]
      # nix-cache
      # nix-tools
      nixconfig
      nixpkgs

      # [ shell ]
      alias
      bash
      # fish
      # zsh
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

      environment.systemPackages = with pkgs; [
        impala # tui wifi for iwd
        brightnessctl # brightnessctl set 50%
      ];

      # [ selfhosted ]
      # services.homepage-dashboard.enable = true;
      services.navidrome.enable = true;
      # services.dufs.enable = true;
      services.goshs.enable = true;
      # services.miniflux.enable = true; # wall
      services.memos.enable = true;
      services.aria2.enable = true;
      services.rqbit.enable = true;
      # services.suwayomi-server.enable = true;
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

      # [ firewall ]
      # BT 对等端口必须对外,反代救不了。端口直接取服务选项,不和 ports.nix / 服务配置漂移。
      networking.firewall = {
        allowedTCPPorts = [ config.services.rqbit.peerPort ];
        allowedUDPPorts = [ config.services.rqbit.peerPort ];
        allowedTCPPortRanges = config.services.aria2.settings.listen-port;
        allowedUDPPortRanges = config.services.aria2.settings.listen-port;
      };

      # iwctl -> station wlan0 connect SSID
      networking.wireless.iwd.enable = true;

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

    };
}
