{ lib, ... }:
{
  flake.lib = lib.extend (
    final: prev:
    let
      attrsets = import ./attrsets.nix { lib = final; };
      umport = import ./umport.nix { lib = final; };
      paths = import ./paths.nix { lib = final; };
    in
    {
      custom = attrsets // umport // paths;
    }
  );
}
