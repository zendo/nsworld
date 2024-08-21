{ inputs, ... }:
{
  nixpkgs = {
    overlays = builtins.attrValues inputs.self.overlays;

    config = {
      allowUnfree = true;
      # allowBroken = true;
      # allowInsecure = true;
      # allowUnsupportedSystem = true;
    };
  };
}
