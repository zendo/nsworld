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

    ###############################################
    ##  Add new packages
    ###############################################
    additions =
      final: prev:
      prev.lib.packagesFromDirectoryRecursive {
        inherit (prev) callPackage;
        directory = ../pkgs;
      };

    ###############################################
    ##  Mod existed packages
    ###############################################
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

      # nurl https://github.com/sahaj-b/ghostty-cursor-shaders
      ghostty-cursor-shaders = prev.fetchFromGitHub {
        owner = "sahaj-b";
        repo = "ghostty-cursor-shaders";
        rev = "14f7cd035f1b483dfe46ba11aef7377b6c4c687d";
        hash = "sha256-ky343PVJklT4MqF5whULGwC5e5YfKF7PRGjB+CoBVUI=";
      };

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
    }; # end of modifications
  }; # end of flake.overlays
}
