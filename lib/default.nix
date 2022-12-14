# inputs:
# # personal lib
# let
#   inherit (inputs.nixpkgs) lib;

#   colors = import ./colors.nix lib;
#   system = import ./system.nix inputs;
#   home = import ./home.nix inputs;
# in
#   lib // colors // home // system
# # adding lib is ugly but easier to keep track of things

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
