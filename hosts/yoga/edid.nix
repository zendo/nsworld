# WIP
# https://github.com/edrex/nixos-config
# https://wiki.archlinux.org/title/Kernel_mode_setting
{ config
, pkgs
, ...
}:
let
  chip_edid = pkgs.runCommandNoCC "foo" { } ''
    mkdir -p $out/lib/firmware/edid
    cp ${./dspinfo.bin} $out/lib/firmware/edid/dspinfo.bin
  '';
in
{
  hardware.firmware = [ chip_edid ];

  boot.kernelParams = [
    "drm.edid_firmware=card0-eDP-1:edid/dspinfo.bin"
    # "video=card0-eDP-1:2880x1800@60"
  ];

  boot.initrd.extraFiles."lib/firmware/edid/dspinfo.bin".source = pkgs.runCommandLocal "dsp" { } "cp ${./dspinfo.bin} $out";
}
