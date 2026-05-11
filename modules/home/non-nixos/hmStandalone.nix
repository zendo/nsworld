{ inputs, config, ... }:
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
        overlays = builtins.attrValues config.flake.overlays;
        config.allowUnfree = true;
      };

      extraSpecialArgs = {
        inherit inputs myvars;
      };

      modules = [
        config.flake.modules.homeManager.non-nixos
      ]
      ++ extraModules;
    };
in
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.homeConfigurations = {
    iab = mkHome {
      myvars = {
        user = "iab";
      };
      extraModules = [
        config.flake.modules.homeManager.non-nixos-imports
        config.flake.modules.homeManager.dconf
      ];
    };

    guest = mkHome {
      myvars = {
        user = "guest";
      };
      extraModules = [
        config.flake.modules.homeManager.gui
        config.flake.modules.homeManager.bash
        config.flake.modules.homeManager.firefox
      ];
    };
  };
}
