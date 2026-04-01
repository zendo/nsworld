{ inputs, self, ... }:
let
  mkHost =
    {
      nixpkgs ? inputs.nixpkgs,
      extraModules ? [ ],
      myvars ? {
        user = "";
        host = "";
      },
    }:
    nixpkgs.lib.nixosSystem {
      # flake.nixosConfigurations.host._module.specialArgs
      specialArgs = {
        inherit inputs self myvars;
      };
      modules = [
        {
          networking.hostName = myvars.host;
        }
      ]
      ++ extraModules;
    };
in
{
  flake.nixosConfigurations = {
    # sudo nixos-rebuild --flake .#yoga switch
    yoga = mkHost {
      myvars.user = "iab";
      myvars.host = "yoga";
      extraModules = [
        (self + /hosts/yoga/configuration.nix)
      ];
    };

    # nix build .#nixosConfigurations.svp.config.system.build.toplevel
    # ./result/bin/switch-to-configuration switch
    svp = mkHost {
      myvars.user = "zendo";
      myvars.host = "svp";
      # nixpkgs = inputs.nixpkgs-stable;
      extraModules = [
        (self + /hosts/svp/configuration.nix)
      ];
    };

    # nixos-rebuild --target-host aaa@rmt -S --flake .#rmt switch
    rmt = mkHost {
      myvars.user = "aaa";
      myvars.host = "rmt";
      extraModules = [
        (self + /hosts/rmt/configuration.nix)
      ];
    };

    # nixos-rebuild build-vm --flake .#vmtest
    # nix build .#nixosConfigurations.vmtest.config.system.build.vm
    vmtest = mkHost {
      myvars.user = "test";
      myvars.host = "vmtest";
      extraModules = [
        (self + /hosts/vmtest/configuration.nix)
      ];
    };
  };
}
