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
  harmonyos-sans = prev.callPackage ./harmonyos-sans {};
  gs-night-switcher = prev.callPackage ./gs-night-switcher {};

  zee = prev.callPackage ./zee {};

  konsave = prev.callPackage ./konsave {};
  dialect = prev.callPackage ./dialect {};

  paper = prev.callPackage ./paper {};
}
