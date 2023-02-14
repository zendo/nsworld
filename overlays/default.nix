final: prev: {
  /*
    nix build --impure --expr 'with import <nixpkgs> {}; callPackage ./default.nix {}' -L
    nix build --impure --expr 'with import <nixpkgs> {}; callPackage ./default.nix {}' -L \
    -I $HOME/nsworld # ???
    -I nixpkgs=flake:github:NixOS/nixpkgs/nixos-22.05
    -I nixpkgs=flake:github:NixOS/nixpkgs/$(nixos-version --revision)
  */

  # amdvlk = prev.callPackage ./amdvlk { };
  spotify = prev.callPackage ./spotify { };

  # Data
  nixos-helper = prev.callPackage ./nixos-helper { };
  sddm-theme-astronaut = prev.callPackage ./sddm-theme-astronaut { };

  # RIME
  fcitx5-breeze = prev.callPackage ./fcitx5-breeze { };
  rime-easy-en = prev.callPackage ./rime-easy-en { };
  rime-aurora-pinyin = prev.callPackage ./rime-aurora-pinyin { };

  # electron / appimage
  listen1 = prev.callPackage ./listen1 { };
  koodo-reader = prev.callPackage ./koodo-reader { };
  thorium-reader = prev.callPackage ./thorium-reader { };
  nightpdf = prev.callPackage ./nightpdf { };
  music-you = prev.callPackage ./music-you { };

  # deb / autoPatchelf
  xmind = prev.callPackage ./xmind { };
  freedownloadmanager = prev.callPackage ./freedownloadmanager { };
  clash-verge = prev.callPackage ./clash-verge { };
  clash-verge-source = prev.callPackage ./clash-verge-source { };
  clash-for-windows = prev.callPackage ./clash-for-windows { };
  clash-meta = prev.callPackage ./clash-meta { };
  clash-premium = prev.callPackage ./clash-premium { };

  # C
  xclicker = prev.callPackage ./xclicker { };
  implay = prev.callPackage ./implay { };
  azcomicv = prev.callPackage ./azcomicv { };

  # Rust
  # mousai = prev.callPackage ./mousai {};
  sniffnet = prev.callPackage ./sniffnet { }; # iced
  gnome-metronome = prev.callPackage ./gnome-metronome { };

  # Go

  # Gtk
  paleta = prev.callPackage ./paleta { };

  # Qt
  nekoray = prev.libsForQt5.callPackage ./nekoray { };
  aphototoollibre = prev.libsForQt5.callPackage ./aphototoollibre { };
  v2ray-desktop = prev.libsForQt5.callPackage ./v2ray-desktop { };

  # Python
  iotas = prev.callPackage ./iotas { };
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
  bashly = prev.callPackage ./bashly { };

  # flutter
  spotube = prev.callPackage ./spotube { }; # WIP!!!
  fclash = prev.callPackage ./fclash { };
  # https://github.com/ferraridamiano/ConverterNOW

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
        rev = "bf69d7badacdbef9ff4de203b8d08ee1dd796e30";
        hash = "sha256-raszEq/GkCH8rSFGBzj5rMXWwSR3w8NlJbveY57grUE=";
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
