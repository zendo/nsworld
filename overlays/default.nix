final: prev: {
  /*
   (pkgs.google-chrome.override {
      commandLineArgs = "--ozone-platform-hint=auto --enable-features=VaapiVideoDecoder --use-gl=egl";
   })
   */

  # scripts
  nix-whereis = prev.callPackage ./nix-whereis {};

  # trivial
  harmonyos-sans = prev.callPackage ./harmonyos-sans {};
  misans = prev.callPackage ./misans {};
  newaita-icon-theme = prev.callPackage ./newaita-icon-theme {};

  # rust
  zee = prev.callPackage ./zee {};
  oaf = prev.callPackage ./oaf {};

  # go
  v2raya = prev.callPackage ./v2raya {};
  go-translation = prev.callPackage ./go-translation {};

  # python
  frog = prev.callPackage ./frog {};

  # nodejs
  clash-verge = prev.callPackage ./clash-verge {};
  netease-cloud-music = prev.callPackage ./netease-cloud-music {};

  # gtk
  dippi = prev.callPackage ./dippi {};
  tuner = prev.callPackage ./tuner {};
  app-icon-preview = prev.callPackage ./app-icon-preview {};

  # Override
  # fix .desktop missing
  wl-color-picker =
    prev.wl-color-picker.overrideAttrs
    (oldAttrs: {
      postFixup = ''
        cp -r $out/usr/share $out/share '';
    });

  # mutter hover bug
  gnome = prev.gnome.overrideScope' (gfinal: gprev: {
    mutter = gprev.mutter.overrideAttrs (oldAttrs: {
      src = prev.fetchurl {
        url = "https://gitlab.gnome.org/GNOME/mutter/-/archive/main/mutter-main.tar.gz";
        sha256 = "sha256-ssETPYPsCcvPxqGU0UrI6t4uvam7zmFi/qV63N7TS5c=";
      };
    });
  });

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
