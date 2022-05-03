final: prev: {
  /*
   (gnomeExtensions.dash-to-dock.overrideAttrs
      (oldAttrs: rec {
        src = fetchFromGitLab {
          owner = "kalilinux";
          repo = "packages/gnome-shell-extension-dashtodock";
          rev = "cdbcaaff36162154689d3d40480e5ef20c140537";
          sha256 = "sha256-KyzJYI1X0nd2r6Sl+W7n35hQg1TXFkyonskhTzmmvW0=";
        };
      }))

       (git-cola.overrideAttrs #
      (oldAttrs: {
        postFixup = ''
        mkdir -p $out/share/icons/hicolor
        cp -r $out/share/git-cola/icons/* $out/share/icons/hicolor/ '';
        }))
   */

  # self tools
  # https://github.com/thiagokokada/nix-configs
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
  paper = prev.callPackage ./paper {};
  dippi = prev.callPackage ./dippi {};
  tuner = prev.callPackage ./tuner {};
  notes = prev.callPackage ./notes {};
  app-icon-preview = prev.callPackage ./app-icon-preview {};

  # override
  wl-color-picker = prev.wl-color-picker.overrideAttrs # lack .desktop
      (oldAttrs: {
        postFixup = ''
        cp -r $out/usr/share $out/share '';
      });

  # sddm = prev.sddm.overrideAttrs
  #   (oldAttrs: {
  #     src = prev.fetchFromGitHub {
  #       owner = "sddm";
  #       repo = "sddm";
  #       rev = "e67307e4103a8606d57a0c2fd48a378e40fcef06";
  #       sha256 = "1s6icb5r1n6grfs137gdzfrcvwsb3hvl7ib2zh6931x8pkl1qvxa";
  #     };
  #   });

  #   plasma5Packages = prev.plasma5Packages.overrideScope' (prev: final: {
  #     libsForQt5.sddm = prev.libsForQt5.sddm.overrideAttrs
  #   (oldAttrs: {
  #     src = prev.fetchFromGitHub {
  #       owner = "sddm";
  #       repo = "sddm";
  #       rev = "e67307e4103a8606d57a0c2fd48a378e40fcef06";
  #       sha256 = "1s6icb5r1n6grfs137gdzfrcvwsb3hvl7ib2zh6931x8pkl1qvxa";
  #     };
  #   });
  # });

  # sddm = prev.callPackage ./sddm {};
}
