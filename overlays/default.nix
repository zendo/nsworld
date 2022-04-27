final: prev: {
  /*
   (gnomeExtensions.dash-to-dock.overrideAttrs
   (oldAttrs: rec {
     src = fetchFromGitHub {
       owner = "micheleg";
       repo = "dash-to-dock";
       rev = "9b22c2ed13e1ec261f7b42fe7194401c7afcffb7";
       sha256 = "sha256-p68wGek42icQ5VHPtqSY9Nr25mzmGK14Tdr6D3ePDtE=";
     };
   }))
   */

  # trivial
  harmonyos-sans = prev.callPackage ./harmonyos-sans {};
  misans = prev.callPackage ./misans {};

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
}
