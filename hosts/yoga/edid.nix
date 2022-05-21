# https://github.com/edrex/nixos-config
# https://wiki.archlinux.org/title/Kernel_mode_setting
{
  config,
  pkgs,
  ...
}: {
  hardware.firmware = [
    (pkgs.runCommand "foo" {} "mkdir -pv $out/lib/firmware/edid; cp ${./chipedp.bin} $out/lib/firmware/edid/chipedp.bin")
  ];

  boot.kernelParams = [
    "drm.edid_firmware=card0-eDP-1:edid/chipedp.bin"
    # "video=card0-eDP-1:e"
  ];

  # boot.initrd.extraFiles."sys/module/drm/parameters/edid_firmware".source = pkgs.runCommand "bar" {} "mkdir -pv $out/lib/firmware/edid; cp ${./chipedp.bin} $out/lib/firmware/edid/chipedp.bin";
}
