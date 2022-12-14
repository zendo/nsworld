# https://github.com/tejing1/nixos-config/tree/master/lib
inputs:
let
  inherit (inputs.nixpkgs) lib;
in
rec {
  supportedSystems = [ "aarch64-linux" "x86_64-linux" ];

  genSystems = lib.genAttrs supportedSystems;

  nixpkgsFor = genSystems (system: overlays:
    import inputs.nixpkgs {
      inherit system overlays;
    });

  # TODO
  btrfsInInitrd = lib.any (fs: fs == "btrfs") builtins.config.boot.initrd.supportedFilesystems;
  btrfsInSystem = lib.any (fs: fs == "btrfs") builtins.config.boot.supportedFilesystems;
  btrfsEnable = btrfsInInitrd && btrfsInSystem;
}
