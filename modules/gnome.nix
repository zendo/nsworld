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

    displayManager = {
      gdm.enable = true;
      defaultSession = "gnome";
      autoLogin.user = "${username}";
    };

    desktopManager.gnome.enable = true;
  };

  #############################################
  services = {
    packagekit.enable = false;
    gnome.tracker.enable = false;
    gnome.tracker-miners.enable = false;
    # For systray icons
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  };

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
    gnome.gnome-power-manager
    gnome.gnome-sound-recorder
    # gnome-builder
    # gnome-firmware-updater

    gnomeExtensions.appindicator
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.app-icons-taskbar
    # gnomeExtensions.dash-to-dock
    (gnomeExtensions.dash-to-dock.overrideAttrs
      (oldAttrs: rec {
        src = fetchFromGitLab {
          owner = "kalilinux";
          repo = "packages/gnome-shell-extension-dashtodock";
          rev = "cdbcaaff36162154689d3d40480e5ef20c140537";
          sha256 = "sha256-KyzJYI1X0nd2r6Sl+W7n35hQg1TXFkyonskhTzmmvW0=";
        };
      }))
    gnomeExtensions.dash2dock-lite
    gnomeExtensions.dash-to-panel
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.proxy-switcher
    gnomeExtensions.gnome-clipboard
    gnomeExtensions.clipboard-history
    gnomeExtensions.espresso
    gnomeExtensions.blur-my-shell
    gnomeExtensions.pop-shell
    # gnomeExtensions.arcmenu
    # gnomeExtensions.logo-menu
    # gnomeExtensions.just-perfection
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
}
