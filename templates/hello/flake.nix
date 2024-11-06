{
  description = "Hello world C language";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        hello = (pkgs.callPackage ./default.nix { });
        default = self.packages.${system}.hello;
      };
    };
}
