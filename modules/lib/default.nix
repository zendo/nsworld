{ lib, ... }:
{
  flake.lib = lib.extend (
    final: prev: (import ./attrsets.nix { lib = final; }) // (import ./umport.nix { lib = final; })
  );
}
