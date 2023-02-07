{ config, pkgs, ... }: {

  services = {
    gnome.sushi.enable = true;
    packagekit.enable = false;
    gnome.tracker.enable = false;
    gnome.tracker-miners.enable = false;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome.yelp
    gnome.geary
    gnome.totem
    gnome-photos
    gnome.baobab
    gnome.gnome-music
    gnome.gnome-software
  ];

  environment.systemPackages = with pkgs; [
    gthumb
    # authenticator
    gparted
    dconf2nix
    gnome-randr

    gnome.gnome-tweaks
    gnome.dconf-editor
    gnome.gnome-power-manager
    gnome.gnome-sound-recorder
    # gnome.pomodoro
    # gnome.gnome-boxes
    # gnome-network-displays  # miracast
    # gnome-builder
    # gnome-firmware-updater
  ] ++ (with gnomeExtensions; [
    appindicator
    app-icons-taskbar
    # rocketbar
    dash-to-dock
    dash-to-panel
    night-theme-switcher
    clipboard-history
    # blur-my-shell
    gradient-top-bar
    # weather-oclock
    # proxy-switcher
    # just-perfection
    # user-avatar-in-quick-settings
    space-bar
    dotspaces
    runcat
    # forge
    caffeine
    # gtile
    # pop-shell
    ddterm
    # replace-activities-text
  ]);

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-breeze
      rime-easy-en
      rime-aurora-pinyin
      # fcitx5-chinese-addons
    ];

    # enabled = "ibus";
    # ibus.engines = with pkgs.ibus-engines; [
    #   rime
    #   # libpinyin
    #   # typing-booster
    # ];
  };

  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
