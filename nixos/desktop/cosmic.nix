{
  pkgs,
  ...
}:
{
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
  };

  mods.fcitx.enable = true;

  # environment.systemPackages = with pkgs; [ ];
}
