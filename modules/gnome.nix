{
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    excludePackages = [
      pkgs.xterm
    ];

    displayManager = {
      gdm.enable = true;
      defaultSession = "gnome";
    };

    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [pkgs.gnome.gnome-settings-daemon];

      favoriteAppsOverride = ''
        [org.gnome.shell]
        favorite-apps=[ 'foot.desktop', 'org.gnome.Nautilus.desktop', 'emacs.desktop', 'firefox.desktop']
      '';

      # Override GNOME defaults
      extraGSettingsOverrides = ''
        [org.gnome.system.location]
        enabled=true

        [org.gnome.settings-daemon.plugins.color]
        night-light-enabled=true

        [org.gnome.desktop.peripherals.touchpad]
        tap-to-click=true
        click-method='areas'

        [org.gnome.desktop.input-sources]
        xkb-options=['ctrl:swapcaps']

        [org.gnome.desktop.wm.keybindings]
        activate-window-menu=[]
      '';
    };
  };

  services = {
    packagekit.enable = false;
    gnome.sushi.enable = true;
    gnome.tracker.enable = false;
    gnome.tracker-miners.enable = false;
    udev.packages = [pkgs.gnome.gnome-settings-daemon];
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

  environment.systemPackages = with pkgs;
    [
      gthumb
      authenticator
      # notejot
      # rhythmbox
      gparted
      dconf2nix
      kooha

      gnome.gnome-tweaks
      gnome.dconf-editor
      gnome.gnome-power-manager
      gnome.gnome-sound-recorder
      # gnome-solanum
      # gnome-network-displays  # miracast
      # gnome-builder
      # gnome.gnome-nettool
      # gnome-firmware-updater
    ]
    ++ (with gnomeExtensions; [
      appindicator
      tray-icons-reloaded
      app-icons-taskbar
      shell-configurator
      replace-activities-text
      dash-to-dock
      dash-to-panel
      night-theme-switcher
      clipboard-history
      espresso
      blur-my-shell
      proxy-switcher
      just-perfection
      rocketbar
      # arcmenu
      # gnome-clipboard
      # pop-shell
      # logo-menu
      # kimpanel
      # pixel-saver
      # gesture-improvements
      ddterm
      ideapad-mode
      mpris-indicator-button
    ]);

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  i18n.inputMethod = {
    # enabled = "fcitx5";
    # fcitx5.enableRimeData= true;
    # fcitx5.addons = with pkgs; [
    #   fcitx5-rime
    #   # fcitx5-chinese-addons
    # ];

    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      rime
      # libpinyin
      # typing-booster
    ];
  };
}
