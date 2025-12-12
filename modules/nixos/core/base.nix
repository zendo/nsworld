{ lib, config, ... }:
{
  # Load configs from nixos/modules
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  documentation = {
    enable = lib.mkDefault false;
    doc.enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
  };

  # Filesystem
  services.btrfs.autoScrub.enable =
    config.fileSystems ? "/" && config.fileSystems."/".fsType == "btrfs";
  services.bcachefs.autoScrub.enable =
    config.fileSystems ? "/" && config.fileSystems."/".fsType == "bcachefs";
}
