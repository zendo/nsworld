{
  # https://github.com/nix-community/srvos/blob/main/nixos/server/default.nix
  flake.modules.nixos.server =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      networking.wireless.iwd.enable = true;

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

      # No need for fonts on a server -230 KiB
      fonts.fontconfig.enable = lib.mkDefault false;
      # freedesktop xdg files -13.6 MiB
      xdg.autostart.enable = lib.mkDefault false;
      xdg.icons.enable = lib.mkDefault false;
      xdg.menus.enable = lib.mkDefault false;
      xdg.mime.enable = lib.mkDefault false;
      xdg.sounds.enable = lib.mkDefault false;
    };
}
