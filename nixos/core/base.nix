{
  lib,
  ...
}:
{
  # Load configs from nixos/modules
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  documentation.enable = lib.mkDefault false;
  i18n.defaultLocale = "zh_CN.UTF-8";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.05";
}
