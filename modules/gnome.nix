{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.displayManager = {
    gdm.enable = true;
    autoLogin.user = "iab";
  };

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  services.packagekit.enable = false;
  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome.yelp
    gnome.geary
    gnome.totem
    gnome.gnome-music
    gnome.gnome-software
  ];

  environment.systemPackages = with pkgs; [
    gthumb
    notejot
    gparted
    dconf2nix

    gnome.gnome-tweaks
    gnome.gnome-todo
    gnome.dconf-editor
    gnome.gnome-power-manager
    gnome.gnome-sound-recorder

    gnomeExtensions.appindicator
    # gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.dash-to-dock
    gnomeExtensions.dash-to-panel
    gnomeExtensions.just-perfection
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.proxy-switcher
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.espresso
    # gnomeExtensions.gesture-improvements
    # gnomeExtensions.arcmenu
    # gnomeExtensions.kimpanel # not work?
    # gnomeExtensions.ddterm
    # gnomeExtensions.blur-my-shell
  ];

}
