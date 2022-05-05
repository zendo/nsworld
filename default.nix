# (import
#   (
#     let
#       lock = builtins.fromJSON (builtins.readFile ./flake.lock);
#     in
#       fetchTarball {
#         url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
#         sha256 = lock.nodes.flake-compat.locked.narHash;
#       }
#   )
#   {
#     src = ./.;
#   })
# .defaultNix


{pkgs ? import <nixpkgs> {}}: let
  system = pkgs.system;
  flake = builtins.getFlake (toString ./.);
in {
  inherit flake builtins;
  lib = flake.inputs.nixpkgs.lib;
  pkgs = flake.inputs.nixpkgs.legacyPackages.${system};
}

/*
    # Executed by `nix flake check`
    checks."<system>"."<attr>" = derivation;

    # Executed by `nix build .#<name>`
    packages."<system>"."<attr>" = derivation;

    # Executed by `nix build .`
    defaultPackage."<system>" = derivation;

    # the derivation that is prepared when running `nix develop`
    # defaults to defaultPackage."<system>"
    devShell."<system>" = derivation;

    # Executed by `nix run .#<name>
    apps."<system>"."<attr>" = {
      type = "app";
      program = "<store-path>";
    };
    defaultApp."<system>" = { type = "app"; program = "..."; };
*/
