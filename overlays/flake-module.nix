{ inputs, ... }:
{
  flake.overlays = {
    # nur = inputs.nur.overlay;

    # stable-packages = final: _prev: {
    #   stable = import inputs.nixpkgs-stable {
    #     system = final.system;
    #     config.allowUnfree = true;
    #   };
    # };

    # Add new pkgs
    additions =
      final: prev:
      prev.lib.packagesFromDirectoryRecursive {
        inherit (prev) callPackage;
        directory = ../pkgs/by-name;
      };

    # Mod existed pkgs
    modifications = final: prev: {
      # clash-verge-rev = prev.callPackage ./clash-verge-rev/package.nix { };
      mihomo-party = prev.callPackage ./mihomo-party/package.nix { };

      # fix .desktop missing
      wl-color-picker = prev.wl-color-picker.overrideAttrs (oldAttrs: {
        postFixup = "cp -r $out/usr/share $out/share ";
      });

      # xwayland env for inputMethod & native CSD
      spotify = prev.spotify.overrideAttrs (oldAttrs: {
        postFixup = ''
          substituteInPlace $out/share/applications/spotify.desktop \
            --replace "Exec=spotify %U" "Exec=env NIXOS_OZONE_WL= spotify %U --force-device-scale-factor=2"
        '';
      });

      # spotify = prev.spotify.override {
      #   deviceScaleFactor = 2.0;
      # };

      # Combining overrideAttrs and override
      # librime =
      #   (prev.librime.overrideAttrs (oldAttrs: {
      #     buildInputs = oldAttrs.buildInputs ++ [ prev.luajit ];
      #   })).override
      #     { plugins = [ prev.librime-lua ]; };

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

      # gnomeExtensions =
      #   prev.gnomeExtensions
      #   // {
      #     night-theme-switcher = prev.callPackage ./night-theme-switcher {};
      #   };

      # Python Module Overlays
      # nix build .#python3Packages.pyjokes
      # pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
      #   (python-final: python-prev: {
      #     pyjokes = python-final.callPackage ./python-modules/pyjokes { };
      #   })
      # ];
      # python3 =
      #   let
      #     self = prev.python3.override {
      #       inherit self;
      #       packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
      #     };
      #   in
      #   self;
      # python3Packages = final.python3.pkgs;

      # And etc...
    };
  };
}
