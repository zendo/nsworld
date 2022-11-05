final: prev: {
  # Trivial
  forgit = prev.callPackage ./forgit {};
  nixos-helper = prev.callPackage ./nixos-helper {};
  zhudou-sans = prev.callPackage ./zhudou-sans {};
  adi1090x-plymouth-themes = prev.callPackage ./adi1090x-plymouth-themes {};

  retext = prev.qt6Packages.callPackage ./retext {};

  # C
  ctpv = prev.callPackage ./ctpv {};
  hashrat = prev.callPackage ./hashrat {};
  xclicker = prev.callPackage ./xclicker {};

  # Rust
  app-icon-preview = prev.callPackage ./app-icon-preview {};
  gnome-metronome = prev.callPackage ./gnome-metronome {};
  done = prev.callPackage ./done {};
  mousai = prev.callPackage ./mousai {};
  g4music = prev.callPackage ./g4music {};
  rustplayer = prev.callPackage ./rustplayer {};
  radio-cli = prev.callPackage ./radio-cli {};
  clitrans = prev.callPackage ./clitrans {};
  tiny-games = prev.callPackage ./tiny-games {};

  # Go
  v2raya = prev.callPackage ./v2raya {};
  go-musicfox = prev.callPackage ./go-musicfox {};
  sauce = prev.callPackage ./sauce {};
  sing-box = prev.callPackage ./sing-box {};

  # Python
  # python setup.py install --root=/home/iab/devs/
  textsnatcher = prev.callPackage ./textsnatcher {};
  smile = prev.callPackage ./smile {};
  novelwriter = prev.callPackage ./novelwriter {};
  bt-dualboot = prev.callPackage ./bt-dualboot {};
  konsave = prev.callPackage ./konsave {};
  tiptop-py = prev.callPackage ./tiptop-py {};
  iotas = prev.callPackage ./iotas {};
  auto-editor = prev.callPackage ./auto-editor {};

  # wordbook = prev.callPackage ./wordbook { };
  # Python Module Overlays
  # pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
  #   (python-final: python-prev: {
  #     av = python-final.callPackage ./av {};
  #   })
  # ];
  # python3 =
  #   let
  #     self = prev.python3.override {
  #       inherit self;
  #       packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
  #     }; in
  #     self;
  # python3Packages = final.python3.pkgs;

  # Gtk
  paper = prev.callPackage ./paper {};
  gtklock = prev.callPackage ./gtklock {};
  tubeconverter = prev.callPackage ./tubeconverter {};

  # Java
  spotiflyer = prev.callPackage ./spotiflyer {};

  # Qt
  converseen = prev.libsForQt5.callPackage ./converseen {};
  bitwave = prev.libsForQt5.callPackage ./bitwave {};
  nekoray = prev.libsForQt5.callPackage ./nekoray {};

  # wayland
  hyprpicker = prev.callPackage ./hyprpicker {};
  hybrid-bar = prev.callPackage ./hybrid-bar {};
  wcp = prev.callPackage ./wcp {};

  # Nodejs
  koodo-reader = prev.callPackage ./koodo-reader {};

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

  # librime-charcode = prev.callPackage ./librime-charcode {};
  # librime = prev.librime.override {
  #   plugins = prev.fetchFromGitHub {
  #     owner = "rime";
  #     repo = "librime";
  #     rev = "e20e3993c42fc86c8209e808ed0762aea24261e0";
  #     hash = "sha256-MHDirPoApNfXpc01M+Xq7p+MiS+pJaxuDo3aROc80e0=";
  #   };
  # };

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
  # gnome = prev.gnome.overrideScope' (gfinal: gprev: {
  #   pomodoro = prev.callPackage ./pomodoro {};
  # });

  gnome = prev.gnome.overrideScope' (gfinal: gprev: {
    gdm = gprev.gdm.overrideAttrs (oldAttrs: {
      src = prev.fetchurl {
        url = "https://gitlab.gnome.org/GNOME/gdm/-/archive/main/gdm-main.tar.gz";
        sha256 = "sha256-4Lsfg65HlHDyh0JQKmvFkRSFseYIv1QfEvTp3USLJi0=";
      };
    });
  });

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
