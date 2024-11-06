{ inputs, self, ... }:
{
  flake = {
    inherit inputs;
    # inherit (inputs.nixpkgs) lib;
    flake = builtins.getFlake (toString ../.);
    hosts = self.nixosConfigurations;
    hm = self.nixosConfigurations.yoga.config.home-manager.users;
    n = inputs.nixpkgs.legacyPackages.x86_64-linux;
    selfPkgs = self.legacyPackages.x86_64-linux;
  };
}
