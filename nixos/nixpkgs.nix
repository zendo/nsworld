{ self, ... }:
{
  nixpkgs = {
    overlays = builtins.attrValues self.overlays;

    config = {
      allowUnfree = true;
      # allowBroken = true;
      # allowInsecure = true;
      # allowUnsupportedSystem = true;
    };
  };
}
