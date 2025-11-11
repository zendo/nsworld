{
  inputs,
  username,
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
    sharedModules = [
      ./hm-on-nixos.nix
    ];
    # home-manager user initialize
    users.${username}.home.username = username;
  };
}
