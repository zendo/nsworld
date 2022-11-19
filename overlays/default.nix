final: prev: {
  # Trivial
  forgit = prev.callPackage ./forgit {};
  nixos-helper = prev.callPackage ./nixos-helper {};
  zhudou-sans = prev.callPackage ./zhudou-sans {};
  fcitx5-breeze = prev.callPackage ./fcitx5-breeze {};
  rime-easy-en = prev.callPackage ./rime-easy-en {};
  rime-aurora-pinyin = prev.callPackage ./rime-aurora-pinyin {};
  adi1090x-plymouth-themes = prev.callPackage ./adi1090x-plymouth-themes {};

  # electron / appimage
  thorium-reader = prev.callPackage ./thorium-reader {};
  fluent-reader = prev.callPackage ./fluent-reader {};
  yesplaymusic = prev.callPackage ./yesplaymusic {};
  koodo-reader = prev.callPackage ./koodo-reader {};
  notesnook = prev.callPackage ./notesnook {};
  leafview = prev.callPackage ./leafview {};
  listen1 = prev.callPackage ./listen1 {};
  moosync = prev.callPackage ./moosync {};
  museeks = prev.callPackage ./museeks {};
  upscayl = prev.callPackage ./upscayl {};
  motrix = prev.callPackage ./motrix {};
  linked = prev.callPackage ./linked {};
  siyuan = prev.callPackage ./siyuan {};
  sleek = prev.callPackage ./sleek {};

  # deb / rpm
  xmind = prev.callPackage ./xmind {};
  v2raya = prev.callPackage ./v2raya {};
  abricotine = prev.callPackage ./abricotine {}; # bug
  freedownloadmanager = prev.callPackage ./freedownloadmanager {};

  # C
  ctpv = prev.callPackage ./ctpv {};
  hashrat = prev.callPackage ./hashrat {};
  xclicker = prev.callPackage ./xclicker {};

  # Rust
  done = prev.callPackage ./done {};
  mousai = prev.callPackage ./mousai {};
  g4music = prev.callPackage ./g4music {};
  tiny-games = prev.callPackage ./tiny-games {};
  noteworthy = prev.callPackage ./noteworthy {};
  gnome-metronome = prev.callPackage ./gnome-metronome {};

  # Go

  # Python
  textsnatcher = prev.callPackage ./textsnatcher {};
  smile = prev.callPackage ./smile {};
  bt-dualboot = prev.callPackage ./bt-dualboot {};
  konsave = prev.callPackage ./konsave {};
  tiptop-py = prev.callPackage ./tiptop-py {};
  iotas = prev.callPackage ./iotas {};
  zdict = prev.callPackage ./zdict {};
  wordle-aid = prev.callPackage ./wordle-aid {};
  wordbook = prev.callPackage ./wordbook {};
  gestures-gtk = prev.callPackage ./gestures-gtk {}; #WIP!!
  upscaler = prev.callPackage ./upscaler {};
  dynamic-wallpaper = prev.callPackage ./dynamic-wallpaper {};

  # Python Module Overlays
  pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
    (python-final: python-prev: {
      wn = python-final.callPackage ./python-modules/wn {};
      pyjokes = python-final.callPackage ./python-modules/pyjokes {};
    })
  ];
  python3 =
    let
      self = prev.python3.override {
        inherit self;
        packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
      }; in
      self;
  python3Packages = final.python3.pkgs;

  # Gtk
  gtklock = prev.callPackage ./gtklock {};
  gabutdm = prev.callPackage ./gabutdm {}; # useless
  hackgregator = prev.callPackage ./hackgregator {};

  # Java
  spotiflyer = prev.callPackage ./spotiflyer {};
  mindustry = prev.callPackage ./mindustry {}; # game

  # Qt
  converseen = prev.libsForQt5.callPackage ./converseen {};
  nekoray = prev.libsForQt5.callPackage ./nekoray {};
  qmmp = prev.qt6Packages.callPackage ./qmmp {};
  retext = prev.qt6Packages.callPackage ./retext {};

  # wayland

  # flutter
  spotube = prev.callPackage ./spotube {}; # WIP!!!


  # Libraries
  # lib = prev.lib.extend (finalLib: prevLib:
  # (import ../lib { inherit (prev) lib; })
  # );

  ############# Override ###################
  # fix .desktop missing
  wl-color-picker =
    prev.wl-color-picker.overrideAttrs
    (oldAttrs: {
      postFixup = ''
        cp -r $out/usr/share $out/share '';
    });

  /*
  # node override
  nodePackages = nodePackages.extend (final: prev: { })

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

  # libsForQt5 override
  libsForQt5 = prev.libsForQt5.overrideScope' (finay: prevy: {
    sddm =
      prevy.sddm.overrideAttrs
      (oldAttrs: {
        src = prev.fetchFromGitHub {
          owner = "sddm";
          repo = "sddm";
          rev = "02801666f7c9e82b57fe8198e2084d8fdcff6b91";
          hash = "sha256-KNj1l4jW7moFOC1JkgRqQR0uPcSCMUuVnyKmkL0sDZw=";
        };
        patches = [];
      });
  });
  */
}
