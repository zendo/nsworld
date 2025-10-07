{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (lib.hiPrio uutils-coreutils-noprefix)
    tree
    file
    wget
    curl
    micro
    parted
    gptfdisk
    efibootmgr
    # efitools
  ];

  # Load configs from nixos/modules
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  i18n.defaultLocale = "zh_CN.UTF-8";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.05";
  documentation.enable = lib.mkDefault false;
}
