{ config, ... }:
{
  flake.modules.homeManager.default-imports =
    {
      lib,
      nixosConfig,
      ...
    }:
    {
      imports = [
        config.flake.modules.homeManager.cli-imports
      ]
      ++ lib.optionals nixosConfig.services.graphical-desktop.enable [
        config.flake.modules.homeManager.gui-imports
      ]
      ++ lib.optionals nixosConfig.services.desktopManager.plasma6.enable [
        config.flake.modules.homeManager.plasma-manager
      ]
      ++ lib.optionals nixosConfig.services.desktopManager.gnome.enable [
        config.flake.modules.homeManager.dconf
      ];
    };

  flake.modules.homeManager.cli-imports.imports = with config.flake.modules.homeManager; [
    secrets
    ssh
    nixconfig

    micro
    fresh-editor
    # helix

    cli
    git
    nix-tools

    alias
    atuin
    bash
    # fish
    starship
    # zellij
    zsh

    env
    files
  ];

  flake.modules.homeManager.gui-imports.imports = with config.flake.modules.homeManager; [
    dev
    emacs
    nvim
    vscode
    # zed

    cava
    chrome
    firefox
    gui
    rclone
    vicinae

    # alacritty
    foot
    ghostty
    # kitty

    env
    mime
    xdg
  ];

}
