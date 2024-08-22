{ pkgs, username, ... }:
{
  # mods.fcitx.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      # libpinyin
      (rime.override {
        rimeDataPkgs = [
          pkgs.rime-frost
          # pkgs.rime-ice
        ];
      })
    ];
  };

  services = {
    displayManager.autoLogin.user = "${username}";

    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];

      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    packagekit.enable = false;
    # gnome.sushi.enable = true;
    # gnome.tracker.enable = false;
    # gnome.tracker-miners.enable = false;
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
    gnome.gnome-music
    gnome.gnome-software
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
      gnome.gnome-power-manager
      gnome.gnome-sound-recorder
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
      gradient-top-bar
      top-bar-organizer
      # just-perfection
      runcat
      caffeine
      paperwm
      # ddterm
      improved-osk
      astra-monitor
    ]);

  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
    # package = pkgs.gnomeExtensions.gsconnect;
  };
}
