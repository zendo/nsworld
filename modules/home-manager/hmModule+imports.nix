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
      manual.manpages.enable = false; # HM manuals
      programs.man.enable = false; # man-db
      programs.bash.enable = true;

      imports =
        lib.optionals nixosConfig.services.desktopManager.plasma6.enable [
          config.flake.modules.homeManager.plasma-manager
        ]
        ++ (with config.flake.modules.homeManager; [
          secrets
          # rclone
          # vscode
          files
          xdg
        ]);
    };

}
