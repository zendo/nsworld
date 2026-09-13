{ inputs, config, ... }:
{
  flake.modules.nixos.hmModule = {
    imports = [ inputs.omniflake.flakes.home-manager.nixosModules.home-manager ];
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

  flake.modules.homeManager.home-imports =
    { lib, nixosConfig, ... }:
    {
      # nix eval --json .#modules.homeManager --apply builtins.attrNames | jq -r '.[]'
      imports =
        lib.optionals nixosConfig.services.desktopManager.plasma6.enable [
          config.flake.modules.homeManager.plasma-manager
        ]
        ++ (with config.flake.modules.homeManager; [
          secrets
          ssh
          # ╭──────────────────────────────────────────╮
          # │ EDITOR                                   │
          # ╰──────────────────────────────────────────╯
          dev
          # vscode
          # zed
          # ╭──────────────────────────────────────────╮
          # │ PROGRAMS                                 │
          # ╰──────────────────────────────────────────╯
          # ai
          cli
          gui
          nix-tools
          rclone
          # vicinae
          # ╭──────────────────────────────────────────╮
          # │ SHELL                                    │
          # ╰──────────────────────────────────────────╯
          alias
          # atuin
          bash
          fish
          starship
          # zellij
          zsh
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
