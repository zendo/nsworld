{ pkgs, lib, ... }:

pkgs.writeShellScriptBin "nix-index-updatedb" ''
  set -euo pipefail

  filename="index-x86_64-$(uname | tr A-Z a-z)"
  mkdir -p ~/.cache/nix-index
  pushd ~/.cache/nix-index > /dev/null
  ${pkgs.wget}/bin/wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
  ln -f ''${filename} files
  popd > /dev/null
''
