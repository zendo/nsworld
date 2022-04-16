final: prev: {
  # sources = prev.callPackage (import ./_sources/generated.nix) { };
  # helix = prev.callPackage ./helix.nix { };
  # manix = prev.manix.overrideAttrs (o: rec{
  #   inherit (prev.sources.manix) pname version src;
  # });
  harmonyos-sans = prev.callPackage ./harmonyos-sans {};
  zee = prev.callPackage ./zee {};
  f2 = prev.callPackage ./f2 {};
  ydict = prev.callPackage ./ydict {};
  konsave = prev.callPackage ./konsave {};
  night-theme-test = prev.callPackage ./night-theme-test {};

  # libsForQt5.sddm = prev.sddm.overrideAttrs (oldAttrs: {
  #   src = prev.fetchFromGithHub {
  #     rev = "d19813cb03c7d71b896aead28e5285bc131500a9";
  #   };
  # });
}
