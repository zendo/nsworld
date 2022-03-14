{ config, lib, pkgs, modulesPath, ... }:
# https://discourse.nixos.org/t/how-to-tell-kernel-to-use-a-custom-modeline/5500
let
  # package for edid firmware
  chip_edid = pkgs.runCommand "chip_edid" {} ''
    mkdir -p $out/lib/firmware/edid
    cp ${./chipedp.bin} $out/lib/firmware/edid/chipedp.bin
  '';
in {
  # add pkg to firmware
  hardware.firmware = [ chip_edid ];
  # add kernel param
  boot.kernelParams = [ "drm.edid_firmware=eDP-1:edid/chipedp.bin" ];
}
