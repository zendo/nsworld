{
  lib,
  pkgs,
  config,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # latest zen xanmod_latest
    # kernelParams = ["quite"];
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };

  services.xserver = {
    xkbOptions = "ctrl:swapcaps"; # emacser habit on Xorg
  };

  # services.xserver.displayManager.autoLogin.enable = lib.mkForce false;
}
