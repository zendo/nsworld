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

      # Export flake.packages to flake.overlays.default
      overlayAttrs = config.packages;

      # flake.packages
      packages =
        lib.packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;
          directory = (inputs.self + /pkgs);
        }
        // {
          # nix run .
          default = config.packages.kula;

          appimage-run-extra = pkgs.appimage-run.override {
            extraPkgs =
              pkgs: with pkgs; [
                libthai
                libsecret
                libepoxy
                # libsoup_3
                # libdbusmenu-gtk3
                # libappindicator-gtk3
                # libayatana-appindicator
                # webkitgtk_4_1
              ];
          };

        };
    };
}
