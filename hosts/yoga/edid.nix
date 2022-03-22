{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
# https://github.com/edrex/nixos-config/blob/c7c5f82e18f3b7cfcfe165042f6a2e51fcb3f375/hosts/chip/edid.nix
let
  # package for edid firmware
  chip_edid = pkgs.runCommand "chip_edid" {} ''
    mkdir -p $out/lib/firmware/edid
    cp ${./chipedp.bin} $out/lib/firmware/edid/chipedp.bin
  '';
in {
  # add pkg to firmware
  hardware.firmware = [chip_edid];
  # add kernel param
  boot.kernelParams = ["drm.edid_firmware=eDP-1:edid/chipedp.bin"];
}
