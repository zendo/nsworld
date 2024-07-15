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

    modifications = _: prev: {
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
    };

    # This one brings our custom packages from the 'pkgs' directory
    # additions = final: _prev: import ../pkgs final.pkgs;

    # nix build --impure --expr "(import <nixpkgs> {}).callPackage ./. {}" -L
    default = final: prev: {
      # clash-verge-rev = prev.callPackage ./clash-verge-rev { };
      clash-verge-rev = prev.callPackage ./clash-verge-rev-source { };
      # clash-verge-rev = prev.callPackage ./clash-verge-rev-test { };
      clash-nyanpasu = prev.callPackage ./clash-nyanpasu { };

      # Data
      ns-cli = prev.callPackage ./ns-cli { };
      rime-ice = prev.callPackage ./rime-ice { };
      fcitx5-breeze = prev.callPackage ./fcitx5-breeze { };
      fluent-fcitx5 = prev.callPackage ./fluent-fcitx5 { };

      # AppImage
      moonfm = prev.callPackage ./moonfm { };

      # deb / autoPatchelf
      he3 = prev.callPackage ./he3 { };
      xmind = prev.callPackage ./xmind { };

      # electron ALL WIP!!!
      nightpdf = prev.callPackage ./nightpdf { };
      weektodo = prev.callPackage ./weektodo { };
      thorium-reader = prev.callPackage ./thorium-reader { };

      # C
      azcomicv = prev.callPackage ./azcomicv { };

      # Rust

      # Go
      trzsz-go = prev.callPackage ./trzsz-go { };

      # Gtk

      # Qt

      # Python

      # Python Module Overlays
      # pythonPackagesOverlays =
      #   (prev.pythonPackagesOverlays or [])
      #   ++ [
      #     (python-final: python-prev: {
      #       pyjokes = python-final.callPackage ./python-modules/pyjokes {};
      #     })
      #   ];
      # python3 = let
      #   self = prev.python3.override {
      #     inherit self;
      #     packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
      #   };
      # in
      #   self;
      # python3Packages = final.python3.pkgs;

      # Java

      # flutter

      # gnome extensions
      # gnomeExtensions =
      #   prev.gnomeExtensions
      #   // {
      #     night-theme-switcher = prev.callPackage ./night-theme-switcher {};
      #   };
    };
  };
}
