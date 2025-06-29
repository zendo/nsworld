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
  #         pkgs.rime-ice
  #       ];
  #     })
  #   ];
  # };

  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    packagekit.enable = false;
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

    # nautilus-open-any-terminal = {
    #   enable = true;
    #   terminal = "kitty";
    # };
  };

  # Fix autologin failed: https://wiki.nixos.org/wiki/GNOME#Automatic_login
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

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
  ];

  environment.systemPackages =
    with pkgs;
    [
      gthumb
      # authenticator
      gparted
      gnome-randr
      qadwaitadecorations-qt6

      refine
      dconf-editor
      gnome-power-manager
      gnome-sound-recorder
    ]
    ++ (with gnomeExtensions; [
      app-hider
      appindicator
      app-icons-taskbar
      # rocketbar
      dash-to-dock
      # dash-to-panel
      night-theme-switcher
      clipboard-history
      # blur-my-shell
      top-bar-organizer
      compiz-windows-effect
      # just-perfection
      kimpanel
      runcat
      caffeine
      paperwm
      tiling-shell
      # ddterm
    ]);
}
