{ inputs, ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      system,
      config,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ inputs.self.overlays.modifications ];
        config = {
          allowUnfree = true;
          # allowInsecure = true;
          android_sdk.accept_license = true;
        };
      };

      # nix build .#
      # quickly access nixpkgs packages without specifying `legacyPackages.<arch>`
      # legacyPackages = pkgs;

      # flake.packages
      packages =
        lib.packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;
          directory = (inputs.self + /pkgs);
        }
        // {
          # nix run .
          default = config.packages.kula;
        };
    };
}
