final: prev: {
  # scripts
  forgit = prev.callPackage ./forgit {};
  getip = prev.callPackage ./getip {};
  tfetch = prev.callPackage ./tfetch {};
  nix-index-updatedb = prev.callPackage ./nix-index-updatedb {};
  ns = prev.callPackage ./nixos-scripts {};

  # rust
  battop = prev.callPackage ./battop {}; # wip
  zee = prev.callPackage ./zee {};       # wip
  decoder = prev.callPackage ./decoder {}; # wip
  artem = prev.callPackage ./artem {};
  mprober = prev.callPackage ./mprober {};
  app-icon-preview = prev.callPackage ./app-icon-preview {};
  netease-cloud-music-gtk = prev.callPackage ./netease-cloud-music-gtk {};
  video-trimmer = prev.callPackage ./video-trimmer {};
  code-radio-cli = prev.callPackage ./code-radio-cli {};
  image-roll = prev.callPackage ./image-roll {};

  # go
  v2raya = prev.callPackage ./v2raya {};
  frei = prev.callPackage ./python {};
  radioboat = prev.callPackage ./radioboat {};
  hysteria = prev.callPackage ./hysteria {};
  dict = prev.callPackage ./dict {};
  gls = prev.callPackage ./gls {};

  # python
  dynamic-wallpaper = prev.callPackage ./dynamic-wallpaper {};
  gpu-viewer = prev.callPackage ./gpu-viewer {};
  frog = prev.callPackage ./frog {};

  # nodejs
  clash-verge = prev.callPackage ./clash-verge {};

  # gtk
  dippi = prev.callPackage ./dippi {};
  paper = prev.callPackage ./paper {};
  g4music = prev.callPackage ./g4music {};

  # libraries
  librime-charcode = prev.callPackage ./librime-charcode {};

  collision = prev.callPackage ./collision {};
  media-downloader = prev.callPackage ./media-downloader {};

  #############################################

  # Override
  # fix .desktop missing
  wl-color-picker =
    prev.wl-color-picker.overrideAttrs
    (oldAttrs: {
      postFixup = ''
        cp -r $out/usr/share $out/share '';
    });

  # librime = prev.librime.override {
  #   plugins = [librime-charcode];
  # };

  # rust override
  # shadowsocks-rust = prev.shadowsocks-rust.overrideAttrs (oldAttrs: rec {
  #   version = "2022-06-27";
  #   src = prev.fetchFromGitHub {
  #     owner = "shadowsocks";
  #     repo = "shadowsocks-rust";
  #     rev = "a4955a198bdf6ab12e647b04180679dfef53fb0b";
  #     sha256 = "sha256-sJKuGQH5PBOcFOpks8sUaAWJlfg7aCv6YS9DWaEF3K4=";
  #   };
  #   cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
  #       inherit src;
  #       outputHash = "sha256-YJ4Qva4keOk9aBPFwztkTpvS7uv7zl6TOHqYZzZEGAs=";
  #     });
  # });

  # gdm bug
  # gnome = prev.gnome.overrideScope' (gfinal: gprev: {
  #   gdm = gprev.gdm.overrideAttrs (oldAttrs: {
  #     src = prev.fetchurl {
  #       url = "https://gitlab.gnome.org/GNOME/gdm/-/archive/main/gdm-main.tar.gz";
  #       sha256 = "sha256-4Lsfg65HlHDyh0JQKmvFkRSFseYIv1QfEvTp3USLJi0=";
  #     };
  #   });
  # });

  # gnome = prev.gnome.overrideScope' (gfinal: gprev: {
  #   mutter = gprev.mutter.overrideAttrs (oldAttrs: rec {
  #     dynamic-buffering = prev.fetchurl {
  #       url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2487.patch";
  #       sha256 = "sha256-KVerFwEgLaEpp5lFofX7VnbBPP4dIVm3+odVUZ8clYA=";
  #     };
  #     patches = dynamic-buffering;
  #   });
  # });

  # sddm-git
  # libsForQt5 = prev.libsForQt5.overrideScope' (finay: prevy: {
  #   sddm =
  #     prevy.sddm.overrideAttrs
  #     (oldAttrs: {
  #       src = prev.fetchFromGitHub {
  #         owner = "sddm";
  #         repo = "sddm";
  #         rev = "e67307e4103a8606d57a0c2fd48a378e40fcef06";
  #         sha256 = "sha256-FfbYQrHndU7rtI8CKK7wtn3pdufBSiXUgefozCja4Do=";
  #       };
  #       patches = [];
  #     });
  # });
}
