final: prev: {
  # scripts
  forgit = prev.callPackage ./forgit {};
  nix-index-updatedb = prev.callPackage ./nix-index-updatedb {};

  # rust
  zee = prev.callPackage ./zee {};
  mprober = prev.callPackage ./mprober {};
  app-icon-preview = prev.callPackage ./app-icon-preview {};
  netease-cloud-music-gtk = prev.callPackage ./netease-cloud-music-gtk {};

  # go
  v2raya = prev.callPackage ./v2raya {};
  frei = prev.callPackage ./frei {};

  # python
  dynamic-wallpaper = prev.callPackage ./dynamic-wallpaper {};

  # nodejs
  clash-verge = prev.callPackage ./clash-verge {};

  # gtk
  dippi = prev.callPackage ./dippi {};
  paper = prev.callPackage ./paper {};
  blueprint-compiler = prev.callPackage ./blueprint-compiler {};

  #############################################

  # Override
  # fix .desktop missing
  wl-color-picker =
    prev.wl-color-picker.overrideAttrs
    (oldAttrs: {
      postFixup = ''
        cp -r $out/usr/share $out/share '';
    });

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
