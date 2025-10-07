{ inputs, ... }:
{
  flake.lib = inputs.nixpkgs.lib.extend (
    final: prev: import ./attrsets.nix { lib = final; } // import ./umport.nix { lib = final; }
  );
}
