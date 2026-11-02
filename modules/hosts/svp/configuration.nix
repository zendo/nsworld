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
      ssh-hosts
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

      # iwctl -> station wlan0 connect SSID
      networking.wireless.iwd.enable = true;

      environment.systemPackages = with pkgs; [
        impala # tui wifi for iwd
        brightnessctl # brightnessctl set 50%
      ];

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

      # services.tailscale = {
      #   enable = true;
      # };

      services.caddy = {
        enable = true;
        # /navidrome.home.arpa/goshs.home.arpa/miniflux.home.arpa/memos.home.arpa/aria2.home.arpa/rqbit.home.arpa/sub-store.home.arpa/comigo.home.arpa/beszel.home.arpa/192.168.2.30
        virtualHosts = {
          "http://navidrome.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:4539
          '';

          "http://goshs.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:8009
          '';

          "http://webdav.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:8001
          '';

          # demo / 123456
          "http://miniflux.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:8081
          '';

          "http://memos.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:5239
          '';

          # http://aria2.home.arpa:80/jsonrpc
          "http://aria2.home.arpa".extraConfig = ''
            handle /jsonrpc {
              reverse_proxy 127.0.0.1:6800
            }
            handle {
              root * ${pkgs.ariang}/share/ariang
              encode zstd gzip
              file_server
            }
          '';

          "http://rqbit.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:3039
          '';

          "http://sub-store.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:3009
          '';

          "http://comigo.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:1239
          '';

          "http://beszel.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:8099
          '';
        };
      };

    };
}
