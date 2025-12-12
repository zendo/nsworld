/*
  # update an unstable package to the latest commit of the default branch
  nix-update --commit --flake --version=branch

  nix build --impure --expr 'with (import <nixpkgs>{}); soxr.overrideAttrs(oldAttrs: {outputs = [ "out" ];})'
*/
{ inputs, ... }:
{
  # Collection of overlays definitions
  flake.overlays = {
    # =========================================================================
    # Inputs Overlays
    # =========================================================================
    # nur = inputs.nur.overlay;
    # emacs-overlay = inputs.emacs-overlay.overlay;

    # https://wiki.nixos.org/wiki/Flakes#Importing_packages_from_multiple_nixpkgs_branches
    # stable-packages = final: _prev: {
    #   stable = import inputs.nixpkgs-stable {
    #     system = final.system;
    #     config.allowUnfree = true;
    #   };
    # };

    # =========================================================================
    # Adding Packages
    # =========================================================================
    additions =
      final: prev:
      prev.lib.packagesFromDirectoryRecursive {
        inherit (prev) callPackage;
        directory = ../packages;
      };

    # =========================================================================
    # Modifying Packages
    # =========================================================================
    plasma-workspace-workaround = import ./plasma-workspace.nix;

    modifications = final: prev: {
      # foo = prev.callPackage ./foo/package.nix { };

      # niri = prev.niri.overrideAttrs (
      #   finalAttrs: prevAttrs: {
      #     # version = "25.08-unstable-2025-11-24";
      #     cargoHash = "sha256-wGqKiinu2K2uRapVSTpRekuwY9P2OukzL7H0R+VR8N8=";
      #     src = prev.fetchFromGitHub {
      #       owner = "YaLTeR";
      #       repo = "niri";
      #       rev = "79e41d7d88de44356b48400515076bf5593544e8";
      #       hash = "sha256-TNtOfYXppR5ln5Go8ncQFMs5+xa3LqJWkaQq22ymAcI=";
      #     };
      #     doCheck = false;
      #     cargoDeps = prev.rustPlatform.fetchCargoVendor {
      #       inherit (finalAttrs) pname src version;
      #       hash = finalAttrs.cargoHash;
      #     };
      #   }
      # );

      # https://github.com/reF1nd/sing-box/tags
      # sing-box = prev.sing-box.overrideAttrs (oldAttrs: rec {
      #   version = "1.12.12-reF1nd";
      #   src = prev.fetchFromGitHub {
      #     owner = "reF1nd";
      #     repo = "sing-box";
      #     tag = "v${version}";
      #     hash = "sha256-7hV9cHXEEYXY6v/4v1z/QjnHgI13F1YLdFjW6giOzbI=";
      #   };
      #   vendorHash = "sha256-d44VxELcjgbP2Ei6gc/zh3Jg2b1N/gnSQf8vR5rCuBk=";
      # });

      # xwayland env for inputMethod & native CSD
      spotify = prev.spotify.overrideAttrs (oldAttrs: {
        postFixup = ''
          substituteInPlace $out/share/applications/spotify.desktop \
            --replace-fail "Exec=spotify %U" "Exec=env NIXOS_OZONE_WL= spotify %U"
        '';
      });

      # Remove attributes from set
      # gui-for-singbox = prev.gui-for-singbox.overrideAttrs (oldAttrs: {
      #   meta = builtins.removeAttrs oldAttrs.meta [
      #     "hydraPlatforms"
      #   ];
      # });

      # NPM/Node.js Tool Wrapper
      # tool-name = prev.writeShellScriptBin "tool-name" ''
      #   export PATH="${prev.nodejs}/bin:$PATH"
      #   exec ${prev.nodejs}/bin/npx --yes package-name "$@"
      # '';

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

      # -----------------------------------------------------------------------
      # Python Module Overlays
      # -----------------------------------------------------------------------
      # nix build .#python3Packages.pyjokes
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (
          python-final: python-prev:
          prev.lib.packagesFromDirectoryRecursive {
            inherit (prev.python3Packages) callPackage;
            directory = ./python-modules;
          }
        )
        # (python-final: python-prev: {
        #   pyjokes = python-final.callPackage ./python-modules/pyjokes { };
        #   # foo = python-prev.foo.overridePythonAttrs (oldAttrs: {
        #   #   ...
        #   # });
        # })
      ];

      # -----------------------------------------------------------------------
      # Gnome Extensions
      # -----------------------------------------------------------------------
      # gnomeExtensions = prev.gnomeExtensions // {
      #   night-theme-switcher = prev.callPackage ./night-theme-switcher { };
      # };

      # -----------------------------------------------------------------------
      # qt6Packages overrideScope
      # -----------------------------------------------------------------------
      qt6Packages = prev.qt6Packages.overrideScope (
        qt6final: qt6prev: {
          # Disable `fcitx5-configtool` to avoid pulling in KDE frameworks dependencies
          fcitx5-with-addons = qt6prev.fcitx5-with-addons.override { withConfigtool = false; };
        }
      );

      # etc...
    }; # end of modifications
  }; # end of flake.overlays
}
