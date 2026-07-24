{ inputs, config, ... }:
{
  flake.modules.nixos.hmModule = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm_bak~";
      overwriteBackup = true;
      sharedModules = [
        (
          { nixosConfig, ... }:
          {
            # home.enableNixpkgsReleaseCheck = false;
            home.stateVersion = nixosConfig.system.stateVersion;
          }
        )
      ];
    };
  };

  flake.modules.homeManager.default-imports =
    { lib, nixosConfig, ... }:
    {
      # nix eval --json .#modules.homeManager --apply builtins.attrNames | jq -r '.[]'
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
          # vicinae
          # ╭──────────────────────────────────────────╮
          # │ SHELL                                    │
          # ╰──────────────────────────────────────────╯
          alias
          atuin
          bash
          fish
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
