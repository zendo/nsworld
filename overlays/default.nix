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

  # rust apps
  zee = prev.callPackage ./zee {};

  # go apps

  # python apps
  konsave = prev.callPackage ./konsave {};
  frog = prev.callPackage ./frog {};
  dialect = prev.callPackage ./dialect {};

  # nodejs apps
  clash-verge = prev.callPackage ./clash-verge {};

  # gtk apps
  paper = prev.callPackage ./paper {};
  dippi = prev.callPackage ./dippi {};
  tuner = prev.callPackage ./tuner {};
}
