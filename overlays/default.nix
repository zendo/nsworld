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

  # trivial
  harmonyos-sans = prev.callPackage ./harmonyos-sans {};
  misans = prev.callPackage ./misans {};
  newaita = prev.callPackage ./newaita {};

  # rust
  zee = prev.callPackage ./zee {};
  oaf = prev.callPackage ./oaf {};

  # go
  v2raya = prev.callPackage ./v2raya {};

  # python
  frog = prev.callPackage ./frog {};

  # nodejs
  clash-verge = prev.callPackage ./clash-verge {};

  # gtk
  paper = prev.callPackage ./paper {};
  dippi = prev.callPackage ./dippi {};
  tuner = prev.callPackage ./tuner {};
  notes = prev.callPackage ./notes {};
  app-icon-preview = prev.callPackage ./app-icon-preview {};
}
