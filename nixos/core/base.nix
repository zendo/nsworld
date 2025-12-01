{ lib, config, ... }:
{
  # Load configs from nixos/modules
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  i18n.defaultLocale = "zh_CN.UTF-8";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.05";

  documentation = {
    enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
  };

  # Filesystem
  services.btrfs.autoScrub.enable =
    config.fileSystems ? "/" && config.fileSystems."/".fsType == "btrfs";
  services.bcachefs.autoScrub.enable =
    config.fileSystems ? "/" && config.fileSystems."/".fsType == "bcachefs";
}
