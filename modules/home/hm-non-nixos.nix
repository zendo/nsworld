{
  flake.modules.homeManager.hm-non-nixos =
    {
      pkgs,
      inputs,
      myvars,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        secrets
        ssh
        nixconfig
        # ╭──────────────────────────────────────────╮
        # │ EDITOR                                   │
        # ╰──────────────────────────────────────────╯
        # dev
        # emacs
        helix
        micro
        nvim
        # vscode
        # zed
        # ╭──────────────────────────────────────────╮
        # │ PROGRAMS                                 │
        # ╰──────────────────────────────────────────╯
        cava
        # chrome
        cli
        # .firefox
        git
        # gui
        nix-tools
        # rclone
        # vicinae
        # ╭──────────────────────────────────────────╮
        # │ SHELL                                    │
        # ╰──────────────────────────────────────────╯
        alias
        atuin
        # bash
        fish
        starship
        zellij
        zsh
        # ╭──────────────────────────────────────────╮
        # │ TERMINAL                                 │
        # ╰──────────────────────────────────────────╯
        # alacritty
        foot
        ghostty
        # kitty
        # ╭──────────────────────────────────────────╮
        # │ XDG                                      │
        # ╰──────────────────────────────────────────╯
        env
        files
        # mime
        xdg
      ];

      # ========================================================
      #  Home
      # ========================================================
      home = {
        packages = with pkgs; [
          dippi
          goodvibes
        ];

        username = "${myvars.user}";
        homeDirectory = "/home/${myvars.user}";
        stateVersion = "26.05";
      };

      # ========================================================
      #  Home-manager Settings
      # ========================================================
      news.display = "silent";
      programs.home-manager.enable = true;
      # https://github.com/nix-community/home-manager/blob/master/docs/manual/usage/gpu-non-nixos.md
      targets.genericLinux.gpu.enable = true;

      # ========================================================
      #  Nix Settings
      # ========================================================
      nix = {
        package = pkgs.nixVersions.stable;
        registry = {
          self.flake = inputs.self;
          nixpkgs.flake = inputs.nixpkgs;
          n.flake = inputs.nixpkgs;
        };
        settings = {
          warn-dirty = false;
          experimental-features = [
            "flakes"
            "nix-command"
          ];
          substituters = [
            # "https://nix-community.cachix.org"
            "https://cache.garnix.io"
            "https://cache.nixos.org"
          ];
          trusted-public-keys = [
            # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ];
        }; # end of settings
      }; # end of nix

      # ========================================================
      #  Fonts Config
      # ========================================================
      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          monospace = [
            "Noto Sans Mono CJK SC"
            "Sarasa Mono SC"
            "DejaVu Sans Mono"
          ];
          sansSerif = [
            "Noto Sans CJK SC"
            "Source Han Sans SC"
            "DejaVu Sans"
          ];
          serif = [
            "Noto Serif CJK SC"
            "Source Han Serif SC"
            "DejaVu Serif"
          ];
        }; # end of defaultFonts
      }; # end of fontconfig
    };
}
