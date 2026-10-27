{ inputs, config, ... }:
let
  userName = "zendo";
  hostName = "svp";
  fm = config.flake.modules;
in
{
  # nixos-rebuild --target-host root@svp --flake .#svp boot --install-bootloader
  flake.nixosConfigurations.svp = inputs.nixpkgs.lib.nixosSystem {
    modules = with fm.nixos; [
      host-svp
      host-svp-disko-btrfs
      hjemModule

      # [ profiles ]
      # gpu-intel

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

  # https://github.com/nix-community/srvos/blob/main/nixos/server/default.nix
  flake.modules.nixos.host-svp =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      myVars.user = userName;
      networking.hostName = hostName;
      networking.wireless.iwd.enable = true;
      users.defaultUserShell = pkgs.zsh;

      # No need for fonts on a server -230 KiB
      fonts.fontconfig.enable = lib.mkDefault false;
      # freedesktop xdg files -13.6 MiB
      xdg.autostart.enable = lib.mkDefault false;
      xdg.icons.enable = lib.mkDefault false;
      xdg.menus.enable = lib.mkDefault false;
      xdg.mime.enable = lib.mkDefault false;
      xdg.sounds.enable = lib.mkDefault false;

      environment = {
        enableAllTerminfo = true;
        variables.BROWSER = "echo";
        # stub-ld.enable = lib.mkDefault false;
      };

      environment.systemPackages = with pkgs; [
        impala # tui wifi for iwd
        brightnessctl # brightnessctl set 50%
        dix
        herdr
        just
        jq
        sqlite
        openssl
        fresh-editor
        # inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.wrapper-git
        gitMinimal # -30.1 MiB
        delta
        ouch
        # [ FileManager ]
        eza
        bat
        fd
        ripgrep
        file
        tree
        # erdtree
        fzf
        skim
        yazi
        gdu
        duf
        dysk
        # f2
        # sd
        xcp
        # choose
        rsync
        lazyssh
        chafa # image viewer
        # viu # image viewer
        gtrash
        # croc
        sendme
        # [ System Monitor ]
        # fastfetch -c examples/7 14
        fastfetch-unwrapped
        btop
        htop
        # bottom
        ctop # containers monitor
        iotop-c
        dool # py fork of dstat
        powertop
        # psmisc # pstree
        procs
        ikill
        # [ Networking ]
        wget
        curl
        aria2
      ];

      # Blank the console after 10 minutes of inactivity.
      boot.kernelParams = [ "consoleblank=600" ];

      services.logind.settings.Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
      };

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
      services.miniflux.enable = true;
      services.memos.enable = true;
      services.rqbit.enable = true;
      # services.suwayomi-server.enable = true;
      systemd.services.kula.enable = true;
      systemd.services.sub-store.enable = true;
      systemd.services.comigo.enable = true;
      systemd.services.mango-manga.enable = true;
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
