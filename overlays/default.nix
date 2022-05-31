final: prev: {
  # scripts
  forgit = prev.callPackage ./forgit {};

  # trivial
  harmonyos-sans = prev.callPackage ./harmonyos-sans {};
  misans = prev.callPackage ./misans {};

  # rust
  zee = prev.callPackage ./zee {};
  mprober = prev.callPackage ./mprober {};

  # go
  v2raya = prev.callPackage ./v2raya {};

  # python
  frog = prev.callPackage ./frog {};

  # nodejs

  # gtk
  dippi = prev.callPackage ./dippi {};

  #############################################

  # Override
  # fix .desktop missing
  wl-color-picker =
    prev.wl-color-picker.overrideAttrs
    (oldAttrs: {
      postFixup = ''
        cp -r $out/usr/share $out/share '';
    });

  # ibus bug
  # ibus = prev.ibus.overrideAttrs (oldAttrs: {
  #   src = prev.pkgs.fetchFromGitHub {
  #     owner = "ibus";
  #     repo = "ibus";
  #     rev = "3e5fab4991f4e2e22b56cf57d4dfb779a1d1977c";
  #     sha256 = "sha256-edd3m8CVSlhCdj+TprSsgkN0V0FxOeeMRf4wpCl+KYQ=";
  #   };
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
