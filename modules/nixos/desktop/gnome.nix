{ pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.packagekit.enable = false;
  # services.gnome.tinysparql.enable = false;
  # services.gnome.localsearch.enable = false;

  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };

  environment.gnome.excludePackages = with pkgs; [
    yelp
    sushi # heavyweight
    geary
    totem
    baobab
    gnome-tour
    gnome-photos
    gnome-music
    gnome-software
    decibels
    showtime
  ];

  environment.systemPackages = with pkgs; [
    # authenticator
    refine
    # file-roller
    # peazip
    xarchiver
    gthumb
    gparted
    dconf-editor
    gnome-randr
    gnome-power-manager
    gnome-sound-recorder
    # gnome-extension-manager
    adw-gtk3
    qadwaitadecorations-qt6
  ];
}
