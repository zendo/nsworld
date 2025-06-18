/*
  # update an unstable package to the latest commit of the default branch
  nix-update --flake --version=branch rime-ice

  nix build --impure --expr 'with (import <nixpkgs>{}); soxr.overrideAttrs(oldAttrs: {outputs = [ "out" ];})'
*/
{ inputs, ... }:
{
  flake.overlays = {
    # nur = inputs.nur.overlay;

    # https://wiki.nixos.org/wiki/Flakes#Importing_packages_from_multiple_nixpkgs_branches
    # stable-packages = final: _prev: {
    #   stable = import inputs.nixpkgs-stable {
    #     system = final.system;
    #     config.allowUnfree = true;
    #   };
    # };

    # Add new packages
    additions =
      final: prev:
      prev.lib.packagesFromDirectoryRecursive {
        inherit (prev) callPackage;
        directory = ../pkgs;
      };

    # Mod existed packages
    modifications = final: prev: {
      # mihomo-party = prev.callPackage ./mihomo-party/package.nix { };

      # nurl https://github.com/yokoffing/Betterfox 138.0
      betterfox = prev.pkgs.fetchFromGitHub {
        owner = "yokoffing";
        repo = "Betterfox";
        rev = "138.0";
        hash = "sha256-ci9g4Igy2dc7cDtPy+l6NaaEz8YsD0BSixFaYWYOKTs=";
      };

      # FIXME: https://github.com/NixOS/nixpkgs/issues/332812
      plymouth = prev.plymouth.overrideAttrs (
        { src, ... }:
        {
          version = "24.004.60-unstable-2024-08-28";
          src = src.override {
            rev = "ea83580a6d66afd2b37877fc75248834fe530d99";
            hash = "sha256-GQzf756Y26aCXPyZL9r+UW7uo+wu8IXNgMeJkgFGWnA=";
          };
        }
      );

      # xwayland env for inputMethod & native CSD
      spotify = prev.spotify.overrideAttrs (oldAttrs: {
        postFixup = ''
          substituteInPlace $out/share/applications/spotify.desktop \
            --replace-fail "Exec=spotify %U" "Exec=env NIXOS_OZONE_WL= spotify %U"
        '';
      });

      # wrapProgram $out/bin/telegram-desktop --set QT_QPA_PLATFORM xcb
      logseq-wayland = prev.symlinkJoin {
        name = "logseq";
        paths = [ prev.logseq ];
        nativeBuildInputs = [ prev.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/logseq \
            --add-flags "--socket=wayland --enable-features=UseOzonePlatform --ozone-platform=wayland"
        '';
      };

      kitten-quick-terminal = prev.pkgs.makeDesktopItem {
        name = "kitten-quick-terminal";
        desktopName = "kitten quick terminal";
        exec = "${prev.pkgs.kitty}/bin/kitten quick-access-terminal";
        noDisplay = true;
        startupNotify = false;
      };

      # gnomeExtensions = prev.gnomeExtensions // {
      #   night-theme-switcher = prev.callPackage ./night-theme-switcher { };
      # };

      # Python Module Overlays
      # nix build .#python3Packages.pyjokes
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (python-final: python-prev: {
          pyjokes = python-final.callPackage ./python-modules/pyjokes { };
          # foo = python-prev.foo.overridePythonAttrs (oldAttrs: {
          #   ...
          # });
        })
      ];

      # And etc...
    };
  };
}
