final: prev: {
  # Trivial
  forgit = prev.callPackage ./forgit {};
  wifi-qr = prev.callPackage ./wifi-qr {};
  nixos-helper = prev.callPackage ./nixos-helper {};
  mygrub-theme = prev.callPackage ./mygrub-theme {};
  hyprpicker = prev.callPackage ./hyprpicker {};
  ctpv = prev.callPackage ./ctpv {};
  stpv = prev.callPackage ./stpv {};

  # Fonts
  zhudou-sans = prev.callPackage ./zhudou-sans {};

  # Rust
  done = prev.callPackage ./done {};
  mprober = prev.callPackage ./mprober {};
  app-icon-preview = prev.callPackage ./app-icon-preview {};
  wpaperd = prev.callPackage ./wpaperd {};
  shotman = prev.callPackage ./shotman {};
  mousai = prev.callPackage ./mousai {};
  lockbook = prev.callPackage ./lockbook {};
  game-of-life = prev.callPackage ./game-of-life {};
  git-graph = prev.callPackage ./git-graph {};

  # Go
  v2raya = prev.callPackage ./v2raya {};
  mabel = prev.callPackage ./mabel {};
  go-musicfox = prev.callPackage ./go-musicfox {};

  # Python
  textpieces = prev.callPackage ./textpieces {};
  dool = prev.callPackage ./dool {};
  textsnatcher = prev.callPackage ./textsnatcher {};

  # Gtk
  paper = prev.callPackage ./paper {};
  gtklock = prev.callPackage ./gtklock {};
  tagger = prev.callPackage ./tagger {};

  # Qt
  converseen = prev.libsForQt5.callPackage ./converseen {};
  qv2ray = prev.libsForQt5.callPackage ./qv2ray {};

  # Nodejs
  koodo-reader = prev.callPackage ./koodo-reader {};
  collision = prev.callPackage ./collision {};
  gi-crystal = prev.callPackage ./gi-crystal {};

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
  libadwaita-git = prev.libadwaita.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "libadwaita";
      rev = "0475afa54ee12fc1f691102c8186c7fc06fcd357";
      hash = "sha256-3ESu34HhsycVV2QNtcxfP7YffCGddKqLTtIkzeJc+GE=";
    };
  });

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

  # gdm bug
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

  # sddm-git
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
