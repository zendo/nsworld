final: prev: {
  # sources = prev.callPackage (import ./_sources/generated.nix) { };
  # helix = prev.callPackage ./helix.nix { };
  # manix = prev.manix.overrideAttrs (o: rec{
  #   inherit (prev.sources.manix) pname version src;
  # });
  ydict = prev.callPackage ./ydict {};
  harmonyos-sans = prev.callPackage ./harmonyos-sans {};
}
