{ inputs, ... }:
{
  debug = true; # repl: flake.currentSystem / flake.debug

  # systems for `perSystem`
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

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

      # flake.packages
      packages =
        lib.packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;
          directory = ../../pkgs;
        }
        // {
          # nix run .
          default = config.packages.anich;
        };

      # quickly access nixpkgs packages without specifying `legacyPackages.<arch>`
      # nix build .#
      legacyPackages = pkgs;
    };
}
