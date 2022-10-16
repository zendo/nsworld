{
  lib,
  pkgs,
  config,
  username,
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

  # password: live
  users.users.${username}.hashedPassword = lib.mkForce
    "$6$gOfs.mtl.D9QhwQv$oc7IFrbVSJl2IL7ECRrxoiFEZNu9O1xGT3cn5mo2eyFFQ9awYwvp855yYcsaCG/qqMALiYK3Xv5ycGmer1c0A0";
}
