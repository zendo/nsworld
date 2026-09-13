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
            programs.bash.enable = true;
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
          # ╭──────────────────────────────────────────╮
          # │ PROGRAMS                                 │
          # ╰──────────────────────────────────────────╯
          # ai
          cli
          dev
          gui
          rclone
          # vicinae
          # vscode
          # ╭──────────────────────────────────────────╮
          # │ SHELL                                    │
          # ╰──────────────────────────────────────────╯
          alias
          fish
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
