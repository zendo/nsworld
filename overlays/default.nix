final: prev: {
  # sources = prev.callPackage (import ./_sources/generated.nix) { };
  # helix = prev.callPackage ./helix.nix { };
  # manix = prev.manix.overrideAttrs (o: rec{
  #   inherit (prev.sources.manix) pname version src;
  # });
  harmonyos-sans = prev.callPackage ./harmonyos-sans {};

  # nix-index = prev.nix-index.overrideAttrs (oldAttrs: {
  #   src = prev.fetchFromGithHub {
  #     rev = "f09548f66790d2d7d53f07ad2af62993d7cabb08";
  #   };
  # });

}
