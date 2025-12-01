{ pkgs, ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    packagekit.enable = false;
    # gnome.tinysparql.enable = false;
    # gnome.localsearch.enable = false;
  };

  programs = {
    kdeconnect = {
      # enable = true;
      package = pkgs.valent;
      # package = pkgs.gnomeExtensions.gsconnect;
    };

    # nautilus-open-any-terminal = {
    #   enable = true;
    #   terminal = "kitty";
    # };
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
