{
  flake.modules.nixos.hmModule =
    {
      inputs,
      myvars,
      ...
    }:
    {
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
        ### Common User Initialization ###
        sharedModules = [
          (
            { nixosConfig, ... }:
            {
              # home.enableNixpkgsReleaseCheck = false;
              home.stateVersion = nixosConfig.system.stateVersion;
            }
          )
        ];
        # users.${myvars.user}.home.username = myvars.user;
        ### Specific User Initialization ###
        # home-manager.users.${myvars.user}.imports = [
        #   inputs.self.modules.homeManager.default-imports
        # ];
      };
    };
}
