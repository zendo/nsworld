{ config, pkgs, ... }:

{
  # Intel GPU
  boot.initrd.kernelModules = [ "i915" ];
  services.xserver.videoDrivers = [ "modesetting" ];
  services.xserver.useGlamor = true;

  # prevent the overheating of Intel CPUs
  services.thermald.enable = true;

  # openGL
  hardware.opengl.extraPackages = with pkgs; [
    intel-compute-runtime
    intel-media-driver #LIBVA_DRIVER_NAME=iHD
    vaapiIntel #LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    vaapiVdpau
    libvdpau-va-gl
  ];

  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel ];
}
