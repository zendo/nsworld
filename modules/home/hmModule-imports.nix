{ config, ... }:
{
  flake.modules.homeManager.default-imports =
    { lib, nixosConfig, ... }:
    {
      imports =
        lib.optionals nixosConfig.services.desktopManager.gnome.enable [
          config.flake.modules.homeManager.dconf
        ]
        ++ lib.optionals nixosConfig.services.desktopManager.plasma6.enable [
          config.flake.modules.homeManager.plasma-manager
        ]
        ++ (with config.flake.modules.homeManager; [
          secrets
          ssh
          nixconfig
          # ╭──────────────────────────────────────────╮
          # │ EDITOR                                   │
          # ╰──────────────────────────────────────────╯
          dev
          emacs
          micro
          fresh-editor
          # helix
          # nvim
          vscode
          # zed
          # ╭──────────────────────────────────────────╮
          # │ PROGRAMS                                 │
          # ╰──────────────────────────────────────────╯
          cava
          chrome
          cli
          firefox
          git
          gui
          mpv
          nix-tools
          rclone
          vicinae
          # ╭──────────────────────────────────────────╮
          # │ SHELL                                    │
          # ╰──────────────────────────────────────────╯
          alias
          atuin
          bash
          # fish
          starship
          # zellij
          zsh
          # ╭──────────────────────────────────────────╮
          # │ TERMINAL                                 │
          # ╰──────────────────────────────────────────╯
          # alacritty
          foot
          ghostty
          kitty
          # ╭──────────────────────────────────────────╮
          # │ XDG                                      │
          # ╰──────────────────────────────────────────╯
          env
          files
          mime
          xdg
        ]);
    };
}
