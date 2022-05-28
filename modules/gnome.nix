{
  config,
  pkgs,
  username,
  ...
}: {
  services.xserver = {
    enable = true;
    excludePackages = [
      pkgs.xterm
    ];
  };

  services.xserver.displayManager = {
    gdm.enable = true;
    defaultSession = "gnome";
    autoLogin.user = "${username}";
  };
  # autologin bug https://github.com/NixOS/nixpkgs/issues/103746
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;

  services = {
    packagekit.enable = false;
    gnome.tracker.enable = false;
    gnome.tracker-miners.enable = false;
    udev.packages = [pkgs.gnome.gnome-settings-daemon];
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
    gcolor3
    # authenticator
    # wl-color-picker
    # notejot
    # lollypop
    rhythmbox
    gparted
    dconf2nix
    kooha

    gnome.gnome-tweaks
    gnome.dconf-editor
    gnome.gnome-nettool
    gnome.gnome-power-manager
    gnome.gnome-sound-recorder
    # gnome-builder
    # gnome-firmware-updater

    gnomeExtensions.appindicator
    # gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.app-icons-taskbar
    gnomeExtensions.dash-to-dock
    gnomeExtensions.dash-to-panel
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.clipboard-history
    # gnomeExtensions.gnome-clipboard
    gnomeExtensions.espresso
    gnomeExtensions.blur-my-shell
    gnomeExtensions.proxy-switcher
    gnomeExtensions.just-perfection
    # gnomeExtensions.pop-shell
    # gnomeExtensions.arcmenu
    # gnomeExtensions.logo-menu
    # gnomeExtensions.kimpanel
    # gnomeExtensions.pixel-saver
    # gnomeExtensions.gesture-improvements
    gnomeExtensions.ddterm
    gnomeExtensions.ideapad-mode
    gnomeExtensions.desktop-icons-ng-ding
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
      # libpinyin
      # typing-booster
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverridePackages = [pkgs.gnome.gnome-settings-daemon];

    favoriteAppsOverride = ''
      [org.gnome.shell]
      favorite-apps=[ 'foot.desktop', 'org.gnome.Nautilus.desktop', 'emacs.desktop', 'firefox.desktop']
    '';

    # Override GNOME defaults
    extraGSettingsOverrides = ''
      [org.gnome.shell]
      welcome-dialog-last-shown-version='9999999999'

      [org.gnome.desktop.peripherals.touchpad]
      tap-to-click=true
      click-method='areas'

      [org.gnome.desktop.input-sources]
      xkb-options=['ctrl:swapcaps']
    '';
  };
}
