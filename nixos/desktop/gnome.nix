{ pkgs, ... }:
{
  mods.fcitx.enable = true;

  # i18n.inputMethod = {
  #   enable = true;
  #   type = "ibus";
  #   ibus.engines = with pkgs.ibus-engines; [
  #     # libpinyin
  #     (rime.override {
  #       rimeDataPkgs = [
  #         # pkgs.rime-frost
  #         pkgs.rime-ice
  #       ];
  #     })
  #   ];
  # };

  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];

      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    packagekit.enable = false;
    # gnome.sushi.enable = true;
    # gnome.tinysparql.enable = false;
    # gnome.localsearch.enable = false;
  };

  programs = {
    evince.package = pkgs.papers;
    kdeconnect = {
      # enable = true;
      package = pkgs.valent;
      # package = pkgs.gnomeExtensions.gsconnect;
    };
  };

  # Fix autologin failed: https://nixos.wiki/wiki/GNOME
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.gnome.excludePackages = with pkgs; [
    yelp
    geary
    totem
    baobab
    gnome-tour
    gnome-photos
    gnome-music
    gnome-software
  ];

  environment.systemPackages =
    with pkgs;
    [
      gthumb
      # authenticator
      gparted
      gnome-randr
      qadwaitadecorations-qt6

      gnome-tweaks
      dconf-editor
      gnome-power-manager
      gnome-sound-recorder
      # gnome.pomodoro
      # gnome.gnome-boxes
      # gnome-network-displays
      # gnome-builder
      # gnome-firmware-updater
    ]
    ++ (with gnomeExtensions; [
      app-hider
      appindicator
      app-icons-taskbar
      # rocketbar
      dash-to-dock
      # dash2dock-lite
      # dash-to-panel
      night-theme-switcher
      clipboard-history
      # clipboard-indicator
      # blur-my-shell
      top-bar-organizer
      # just-perfection
      kimpanel
      runcat
      caffeine
      paperwm
      tiling-shell
      # ddterm
    ]);
}
