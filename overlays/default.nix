final: prev: {
  # scripts
  forgit = prev.callPackage ./forgit {};
  nix-index-updatedb = prev.callPackage ./nix-index-updatedb {};

  # rust
  zee = prev.callPackage ./zee {};
  mprober = prev.callPackage ./mprober {};

  # go
  v2raya = prev.callPackage ./v2raya {};
  frei = prev.callPackage ./frei {};

  # python
  dynamic-wallpaper = prev.callPackage ./dynamic-wallpaper {};

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
