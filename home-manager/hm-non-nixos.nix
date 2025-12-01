{
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [
    # ╭──────────────────────────────────────────╮
    # │ EDITOR                                   │
    # ╰──────────────────────────────────────────╯
    # ./editor/dev-tools.nix
    # ./editor/emacs.nix
    ./editor/helix.nix
    ./editor/micro.nix
    ./editor/nvim.nix
    # ./editor/vscode.nix
    # ./editor/zed.nix
    # ╭──────────────────────────────────────────╮
    # │ PROGRAMS                                 │
    # ╰──────────────────────────────────────────╯
    # ./programs/chrome.nix
    ./programs/cli.nix
    # ./programs/firefox.nix
    ./programs/git.nix
    # ./programs/gui.nix
    ./programs/nix-tools.nix
    ./programs/ssh.nix
    # ./programs/vicinae.nix
    # ╭──────────────────────────────────────────╮
    # │ SHELL                                    │
    # ╰──────────────────────────────────────────╯
    ./shell/alias.nix
    ./shell/atuin.nix
    # ./shell/bash.nix
    ./shell/fish.nix
    ./shell/starship.nix
    ./shell/zellij.nix
    ./shell/zsh.nix
    # ╭──────────────────────────────────────────╮
    # │ TERMINAL                                 │
    # ╰──────────────────────────────────────────╯
    # ./terminal/alacritty.nix
    ./terminal/foot.nix
    ./terminal/ghostty.nix
    ./terminal/kitty.nix
    # ╭──────────────────────────────────────────╮
    # │ XDG                                      │
    # ╰──────────────────────────────────────────╯
    # ./xdg/dconf.nix
    ./xdg/env.nix
    ./xdg/files.nix
    # ./xdg/mime.nix
    # ./xdg/plasma.nix
    ./xdg/xdg.nix
  ];

  # =========================================================================
  #  Home
  # =========================================================================
  home = {
    packages = with pkgs; [
      dippi
      goodvibes
    ];

    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
  };

  # =========================================================================
  #  Home-manager Settings
  # =========================================================================
  news.display = "silent";
  programs.home-manager.enable = true;
  # https://github.com/nix-community/home-manager/blob/master/docs/manual/usage/gpu-non-nixos.md
  targets.genericLinux.gpu.enable = true;

  # =========================================================================
  #  Nix Settings
  # =========================================================================
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

  # =========================================================================
  #  Fonts Config
  # =========================================================================
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
}
