final: prev: {
  opera = prev.callPackage ./opera { };
  justfortest = prev.callPackage ./justfortest { };
  nixos-helper = prev.callPackage ./nixos-helper { };

  # Data
  zhudou-sans = prev.callPackage ./zhudou-sans { };
  lxgw-neoxihei-screen = prev.callPackage ./lxgw-neoxihei-screen { };
  sddm-theme-astronaut = prev.callPackage ./sddm-theme-astronaut { };
  adi1090x-plymouth-themes = prev.callPackage ./adi1090x-plymouth-themes { };

  # RIME
  fcitx5-breeze = prev.callPackage ./fcitx5-breeze { };
  rime-easy-en = prev.callPackage ./rime-easy-en { };
  rime-aurora-pinyin = prev.callPackage ./rime-aurora-pinyin { };

  # electron / appimage
  listen1 = prev.callPackage ./listen1 { };
  koodo-reader = prev.callPackage ./koodo-reader { };
  thorium-reader = prev.callPackage ./thorium-reader { };
  nightpdf = prev.callPackage ./nightpdf { };
  # WIP
  # nightpdf = prev.callPackage ./nightpdf-source {
  #   # electron = prev.electron_21;
  # };
  music-you = prev.callPackage ./music-you { };

  # deb / autoPatchelf
  xmind = prev.callPackage ./xmind { };
  clash-verge = prev.callPackage ./clash-verge { };
  # clash-verge-source = prev.callPackage ./clash-verge-source { };
  freedownloadmanager = prev.callPackage ./freedownloadmanager { };

  # C
  xclicker = prev.callPackage ./xclicker { };
  implay = prev.callPackage ./implay { };

  # Rust
  # mousai = prev.callPackage ./mousai {};
  sniffnet = prev.callPackage ./sniffnet { }; # iced
  gnome-metronome = prev.callPackage ./gnome-metronome { };
  charcoal-dict = prev.callPackage ./charcoal-dict { };

  # Go

  # Gtk
  damask = prev.callPackage ./damask { };

  # Qt
  nekoray = prev.libsForQt5.callPackage ./nekoray { };
  aphototoollibre = prev.libsForQt5.callPackage ./aphototoollibre {};

  # Python
  textsnatcher = prev.callPackage ./textsnatcher { };
  bt-dualboot = prev.callPackage ./bt-dualboot { };
  konsave = prev.callPackage ./konsave { };
  iotas = prev.callPackage ./iotas { };
  zdict = prev.callPackage ./zdict { };
  cavalier = prev.callPackage ./cavalier { };
  gestures-gtk = prev.callPackage ./gestures-gtk { }; #WIP!!

  # Python Module Overlays
  pythonPackagesOverlays =
    (prev.pythonPackagesOverlays or [ ])
    ++ [
      (python-final: python-prev: {
        pyjokes = python-final.callPackage ./python-modules/pyjokes { };
      })
    ];
  python3 =
    let
      self = prev.python3.override {
        inherit self;
        packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
      };
    in
    self;
  python3Packages = final.python3.pkgs;

  # Java
  spotiflyer = prev.callPackage ./spotiflyer { };
  mindustry = prev.callPackage ./mindustry { }; # game

  # Ruby
  completely = prev.callPackage ./completely { };
  bashly = prev.callPackage ./bashly { };

  # flutter
  spotube = prev.callPackage ./spotube { }; # WIP!!!

  # Libraries
  # lib = prev.lib.extend (finalLib: prevLib:
  #   (import ../lib { inherit (prev) lib; })
  # );

  ############# Override ###################
  # fix .desktop missing
  wl-color-picker =
    prev.wl-color-picker.overrideAttrs
      (oldAttrs: {
        postFixup = ''
          cp -r $out/usr/share $out/share '';
      });

  # libsForQt5 override
  libsForQt5 = prev.libsForQt5.overrideScope' (finay: prevy: {
    sddm = prevy.sddm.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        owner = "sddm";
        repo = "sddm";
        rev = "3e486499b9300ce8f9c62bd102e5119b27a2fad1";
        hash = "sha256-Y9WPm0MLWl/s0e0aoKKk0SSojqBrI/RdyxkgOz2Tk38==";
      };
      patches = [ ];
    });
  });


  /*
    # node override
    nodePackages = nodePackages.extend (final: prev: { });

    # rust override
    shadowsocks-rust = prev.shadowsocks-rust.overrideAttrs (oldAttrs: rec {
    version = "2022-06-27";
    src = prev.fetchFromGitHub {
      owner = "shadowsocks";
      repo = "shadowsocks-rust";
      rev = "a4955a198bdf6ab12e647b04180679dfef53fb0b";
      sha256 = "sha256-sJKuGQH5PBOcFOpks8sUaAWJlfg7aCv6YS9DWaEF3K4=";
    };
    cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
      inherit src;
      outputHash = "sha256-YJ4Qva4keOk9aBPFwztkTpvS7uv7zl6TOHqYZzZEGAs=";
    });
    });

    # gnome override
    gnome = prev.gnome.overrideScope' (gfinal: gprev: {
    mutter = gprev.mutter.overrideAttrs (oldAttrs: rec {
      dynamic-buffering = prev.fetchurl {
        url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2487.patch";
        sha256 = "sha256-KVerFwEgLaEpp5lFofX7VnbBPP4dIVm3+odVUZ8clYA=";
      };
      patches = dynamic-buffering;
    });
    });
  */

}
