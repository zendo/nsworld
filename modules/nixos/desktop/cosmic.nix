# https://cosmic-themes.org/
{ pkgs, ... }:
{
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  environment.systemPackages = with pkgs; [
    loupe
    tasks
    forecast
    cosmic-ext-ctl
    cosmic-ext-tweaks
    # https://github.com/cosmic-utils/camera
    # https://github.com/cosmic-utils/clipboard-manager
    # cosmic-ext-applet-clipboard-manager
    copyq
    (makeAutostartItem {
      name = "copyq";
      package = copyq;
    })
  ];
}
