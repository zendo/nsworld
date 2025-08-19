{
  lib,
  pkgs,
  config,
  ...
}:
{
  services = {
    acpid.enable = true;
    # fwupd.enable = true;
    btrfs.autoScrub.enable = config.fileSystems."/".fsType == "btrfs";
    journald.extraConfig = ''
      SystemMaxUse=50M
    '';
  };

  environment.systemPackages = with pkgs; [
    (lib.hiPrio uutils-coreutils-noprefix)
    tree
    file
    wget
    curl
    parted
    gptfdisk
    micro
    sbctl
    efibootmgr
    # efitools
  ];

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.05";
  documentation.enable = lib.mkDefault false;

  # Remove perl from activation
  # system.etc.overlay.enable = lib.mkDefault true;
}
