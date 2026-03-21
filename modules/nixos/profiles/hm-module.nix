{
  flake.modules.nixos.hm =
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
        # sharedModules = [ ./hm-on-nixos.nix ];
        # users.${myvars.user}.home.username = myvars.user;
        ### Specific User Initialization ###
        users.${myvars.user} = ../../home/hm-on-nixos.nix;
      };
    };
}
