{
  lib,
  inputs,
}: {
  mkHost = import ./mkHost.nix inputs;
  mkHome = import ./mkHome.nix inputs;
}
