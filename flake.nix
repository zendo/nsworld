{
  description = "NIX SAVE THE WORLD";

  outputs =
    inputs@{ omniflake, ... }:
    omniflake.flakes.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./secrets/secrets-module.nix
        (omniflake.flakes.import-tree ./modules)
      ];
    };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "git+file:///home/iab/Projects/nixpkgs/?ref=pr-throne-430949";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";

    omniflake.url = "github:fzakaria/omniflake";
    omniflake.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    # bash-prompt = "[nix]λ ";
  };
}
