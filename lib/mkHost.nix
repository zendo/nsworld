# https://github.com/fersilva16/nix-config
inputs: let
  inherit (inputs) self nixpkgs nixpkgs-stable home-manager;
in
  {
    hostname,
    username,
    nixpkgs ? inputs.nixpkgs,
    system ? "x86_64-linux",
    hmEnable ? true,
    overlays ? [],
    extraModules ? [],
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs username;};
      modules =
        [
          ../modules/base.nix
          ../modules/user.nix
          ../modules/network.nix
          ../modules/nixconfig.nix
          ../modules/sound.nix
          ../modules/fonts.nix
          ../modules/virtualisation.nix
          ../hosts/${hostname}

          {
            nixpkgs.overlays = overlays;
            hardware.enableAllFirmware = true;
            networking.hostName = "${hostname}";
            # services.xserver.displayManager.autoLogin.user = "${username}";
          }
        ]
        ++ nixpkgs.lib.optionals hmEnable [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit hostname;};
            home-manager.users.${username} = import ../home-manager;
          }
        ]
        ++ extraModules;
    }
