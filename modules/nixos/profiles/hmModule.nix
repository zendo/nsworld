{ inputs, ... }:
{
  flake.modules.nixos.hmModule = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      # using system configuration’s `pkgs` argument
      useGlobalPkgs = true;
      useUserPackages = true;
      # fd hm_bak -H -x rm -r
      backupFileExtension = "hm_bak~";
      overwriteBackup = true;
      extraSpecialArgs = {
        inherit inputs;
      };
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
}
