{
  inputs,
  myvar,
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
    # users.${myvar.user}.home.username = myvar.user;
    ### Specific User Initialization ###
    users.${myvar.user} = ./hm-on-nixos.nix;
  };
}
