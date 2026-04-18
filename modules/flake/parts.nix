{ inputs, ... }:
{
  imports = [
    # for dendritic pattern
    inputs.flake-parts.flakeModules.modules
    # flake.overlays.default
    inputs.flake-parts.flakeModules.easyOverlay
    # flake.formatter
    inputs.treefmt-nix.flakeModule
    # flake.devShells
    inputs.devshell.flakeModule
  ];

  # for repl
  # flake.currentSystem / flake.debug
  debug = true;

  # for perSystem
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
}
