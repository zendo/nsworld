{ inputs, ... }:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.homeConfigurations =
    let
      mkHome =
        {
          myvars ? {
            user = "";
          },
          nixpkgs ? inputs.nixpkgs,
          system ? "x86_64-linux",
          extraModules ? [ ],
        }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = builtins.attrValues inputs.self.overlays;
            config.allowUnfree = true;
          };

          extraSpecialArgs = {
            inherit inputs myvars;
          };

          modules =
            # basic setup
            [
              ./hm-non-nixos.nix
            ]
            # and more modules
            ++ extraModules;
        };
    in
    {
      # main
      iab = mkHome {
        myvars = {
          user = "iab";
        };
        extraModules = [ ./wm/dconf.nix ];
      };

      # MAYBE: other user on nixos
      guest = mkHome {
        myvars = {
          user = "guest";
        };
        extraModules = [
          ./programs/gui.nix
          ./programs/bash.nix
          ./programs/firefox.nix
        ];
      };
    };
}
