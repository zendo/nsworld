let
  flake = builtins.getFlake (toString ./.);
  nixpkgs = import <nixpkgs> {};
in
  {inherit flake;}
  // flake
  // builtins
  // nixpkgs
  // nixpkgs.lib
  // flake.nixosConfigurations
# (import
#   (
#     let lock = builtins.fromJSON (builtins.readFile ./flake.lock); in
#     fetchTarball {
#       url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
#       sha256 = lock.nodes.flake-compat.locked.narHash;
#     }
#   )
#   { src = ./.; }
# ).defaultNix
# {pkgs ? import <nixpkgs> {}}: let
#   system = pkgs.system;
#   flake = builtins.getFlake (toString ./.);
# in {
#   inherit flake builtins;
#   lib = flake.inputs.nixpkgs.lib;
#   pkgs = flake.inputs.nixpkgs.legacyPackages.${system};
# }
# {
#   name ? (with builtins; head (split "\n" (readFile /etc/hostname))),
#   pwd ? builtins.getEnv "PWD",
#   flake ? builtins.getFlake pwd,
#   self ? flake.outputs.nixosConfigurations."${name}",
#   ...
# }@args:
# (args // {
#   inherit self args flake;
#   inherit (flake) inputs outputs;
#   inherit (self) config options pkgs;
#   inherit (self.pkgs) lib;
# })

