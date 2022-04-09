{
  config,
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.displayManager = {
    gdm.enable = true;
    defaultSession = "gnome";
    autoLogin.user = "iab";
  };

  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  services.packagekit.enable = false;
  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome.yelp
    gnome.geary
    gnome.totem
    gnome.baobab
    gnome.gnome-music
    gnome.gnome-software
  ];

  environment.systemPackages = with pkgs; [
    gthumb
    notejot
    lollypop
    rhythmbox
    gparted
    dconf2nix
    kooha
    # fractal

    gnome.gnome-tweaks
    gnome.gnome-todo
    gnome.dconf-editor
    gnome.gnome-power-manager
    gnome.gnome-sound-recorder
    gnome.gnome-boxes

    gnomeExtensions.appindicator
    # gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.dash-to-dock
    gnomeExtensions.dash-to-panel
    # gnomeExtensions.just-perfection
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.proxy-switcher
    gnomeExtensions.gnome-clipboard
    # gnomeExtensions.clipboard-history
    gnomeExtensions.espresso
    gnomeExtensions.blur-my-shell
    gnomeExtensions.pop-shell
    # gnomeExtensions.kimpanel
    # gnomeExtensions.logo-menu
    # gnomeExtensions.pixel-saver
    # gnomeExtensions.gesture-improvements
    # gnomeExtensions.arcmenu
    gnomeExtensions.ddterm
    gnomeExtensions.ideapad-mode
    gnomeExtensions.mpris-indicator-button
  ];

  i18n.inputMethod = {
    # enabled = "fcitx5";
    # fcitx5.addons = with pkgs; [
    #   fcitx5-rime
    #   # fcitx5-chinese-addons
    # ];

    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      rime
      libpinyin
      typing-booster
    ];
  };

}
