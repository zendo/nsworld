{ inputs, config, ... }:
let
  fm = config.flake.modules;
in
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
            manual.manpages.enable = false; # HM manuals
            programs.man.enable = false; # man-db
            programs.bash.enable = true;
          }
        )
      ];
    };
  };

  flake.modules.nixos.hm-imports = { config, ... }: {
    imports = [ fm.nixos.hmModule ];

    home-manager.users.${config.myVars.user} = { lib, nixosConfig, ... }: {
      imports = [
        # fm.homeManager.secrets
        # fm.homeManager.rclone
        # fm.homeManager.vscode
        fm.homeManager.files
        fm.homeManager.xdg
      ]
      ++ lib.optionals nixosConfig.services.desktopManager.plasma6.enable [
        fm.homeManager.plasma-manager
      ];
    };
  };

}
