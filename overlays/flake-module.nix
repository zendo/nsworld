/*
  # update an unstable package to the latest commit of the default branch
  nix-update --commit --flake --version=branch

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

      # nurl https://github.com/yokoffing/Betterfox 144.0
      betterfox = prev.pkgs.fetchFromGitHub {
        owner = "yokoffing";
        repo = "Betterfox";
        rev = "144.0";
        hash = "sha256-sYOjMSFJSq9VWG4S78n3lXExreYXalUAHmEPXP2vnfM=";
      };

      # nurl https://github.com/rafaelmardojai/firefox-gnome-theme v143
      firefox-gnome-theme = prev.fetchFromGitHub {
        owner = "rafaelmardojai";
        repo = "firefox-gnome-theme";
        rev = "v143";
        hash = "sha256-0E3TqvXAy81qeM/jZXWWOTZ14Hs1RT7o78UyZM+Jbr4=";
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

      # https://github.com/reF1nd/sing-box/tags
      # sing-box = prev.sing-box.overrideAttrs (oldAttrs: rec {
      #   version = "1.12.10-reF1nd";
      #   src = prev.fetchFromGitHub {
      #     owner = "reF1nd";
      #     repo = "sing-box";
      #     tag = "v${version}";
      #     hash = "sha256-s2TDZtVIgf/m3iJZHwJSNIsY98wHKua7Ld74szAn/pQ=";
      #   };
      #   vendorHash = "sha256-xsN+cdOFl7OS124xYj2EG1ZIz8MZV+lfbMPj1h+o55Q=";
      # });

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

      # qt6Packages override
      qt6Packages = prev.qt6Packages.overrideScope (
        qt6final: qt6prev: {
          # `fcitx5-configtool` has a heavy dependency KDE Frameworks
          fcitx5-with-addons = qt6prev.fcitx5-with-addons.override { withConfigtool = false; };
          # https://github.com/NixOS/nixpkgs/pull/454184
          fcitx5-qt = qt6prev.fcitx5-qt.overrideAttrs (oldAttrs: {
            patches = (oldAttrs.patches or [ ]) ++ [
              (prev.fetchpatch2 {
                url = "https://github.com/fcitx/fcitx5-qt/commit/46a07a85d191fd77a1efc39c8ed43d0cd87788d2.patch?full_index=1";
                hash = "sha256-qv8Rj6YoFdMQLOB2R9LGgwCHKdhEji0Sg67W37jSIac=";
              })
              (prev.fetchpatch2 {
                url = "https://github.com/fcitx/fcitx5-qt/commit/6ac4fdd8e90ff9c25a5219e15e83740fa38c9c71.patch?full_index=1";
                hash = "sha256-x0OdlIVmwVuq2TfBlgmfwaQszXLxwRFVf+gEU224uVA=";
              })
              (prev.fetchpatch2 {
                url = "https://github.com/fcitx/fcitx5-qt/commit/1d07f7e8d6a7ae8651eda658f87ab0c9df08bef4.patch?full_index=1";
                hash = "sha256-22tKD7sbsTJcNqur9/Uf+XAvMvA7tzNQ9hUCMm+E+E0=";
              })
            ];
          });
        }
      );

      # gnomeExtensions = prev.gnomeExtensions // {
      #   night-theme-switcher = prev.callPackage ./night-theme-switcher { };
      # };

      # Python Module Overlays
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

      # And etc...
    };
  };
}
