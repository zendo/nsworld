{ pkgs, home-manager, system, lib, overlays, ... }:
rec {
  user = import ./meta.nix { inherit pkgs home-manager lib system overlays; };
  host = import ./mkHost.nix { inherit system pkgs home-manager lib user; };
}
