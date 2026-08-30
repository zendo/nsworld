{ inputs, ... }:
{
  # for dendritic pattern
  imports = [ inputs.flake-parts.flakeModules.modules ];

  # for repl
  # flake.currentSystem / flake.debug
  debug = true;

  # for perSystem
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
}
