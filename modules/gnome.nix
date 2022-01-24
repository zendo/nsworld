{ config, pkgs, ... }:

{
  services.xserver.displayManager = {
    gdm.enable = true;
    autoLogin.user = "iab";
  };

  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  services.packagekit.enable = false;
  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome.geary
    gnome.totem
    gnome.yelp
    gnome.gnome-software
    gnome-photos
    gnome.gnome-music
  ];

  environment.systemPackages = with pkgs; [
    gthumb
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
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.proxy-switcher
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.espresso
    gnomeExtensions.just-perfection
    # gnomeExtensions.arcmenu
    # gnomeExtensions.kimpanel # not work?
    # gnomeExtensions.ddterm
    # gnomeExtensions.blur-my-shell
  ];

  # Theme
  # qt5 = {
  #   enable = true;
  #   style = "gtk2";
  #   platformTheme = "gtk2";
  # };

}
