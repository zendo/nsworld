final: prev: {
  /*
    nix build --impure --expr 'with import <nixpkgs> {}; callPackage ./default.nix {}' -L
    nix build --impure --expr 'with import <nixpkgs> {}; callPackage ./default.nix {}' -L \
    -I $HOME/nsworld # ???
    -I nixpkgs=flake:github:NixOS/nixpkgs/nixos-22.05
    -I nixpkgs=flake:github:NixOS/nixpkgs/$(nixos-version --revision)
  */


  # Data
  nixos-helper = prev.callPackage ./nixos-helper { };
  zhudou-sans = prev.callPackage ./zhudou-sans { };
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
  clash-verge = prev.callPackage ./clash-verge { };
  clash-verge-source = prev.callPackage ./clash-verge-source { };
  freedownloadmanager = prev.callPackage ./freedownloadmanager { };

  # C
  xclicker = prev.callPackage ./xclicker { };
  implay = prev.callPackage ./implay { };
  azcomicv = prev.callPackage ./azcomicv { };

  # Rust
  # mousai = prev.callPackage ./mousai {};
  sniffnet = prev.callPackage ./sniffnet { }; # iced
  gnome-metronome = prev.callPackage ./gnome-metronome { };
  charcoal-dict = prev.callPackage ./charcoal-dict { };

  # Go
  clash-meta = prev.callPackage ./clash-meta { };
  clash-premium = prev.callPackage ./clash-premium { };

  # Gtk
  paleta = prev.callPackage ./paleta { };

  # Qt
  nekoray = prev.libsForQt5.callPackage ./nekoray { };
  aphototoollibre = prev.libsForQt5.callPackage ./aphototoollibre { };

  # Python
  textsnatcher = prev.callPackage ./textsnatcher { };
  bt-dualboot = prev.callPackage ./bt-dualboot { };
  konsave = prev.callPackage ./konsave { };
  iotas = prev.callPackage ./iotas { };
  zdict = prev.callPackage ./zdict { };
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
        rev = "c42bb38036eae02c1fe274a37c5a9b4915146004";
        hash = "sha256-h9XPVCYb7RB+XqyV19klqEhR60HKCTThIOJtbroRmcQ=";
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
