{ inputs, ... }:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.homeConfigurations =
    let
      mkHome =
        {
          username,
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
            inherit inputs username;
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
        username = "iab";
        extraModules = [ ./xdg/dconf.nix ];
      };

      # MAYBE: other user on nixos
      guest = mkHome {
        username = "guest";
        extraModules = [
          ./programs/gui.nix
          ./programs/bash.nix
          ./programs/firefox.nix
        ];
      };
    };
}
