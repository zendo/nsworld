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
      # autoLogin.user = "${username}";
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
    gnome.gnome-nettool
    gnome.gnome-power-manager
    gnome.gnome-sound-recorder
    # gnome-builder
    # gnome-firmware-updater

    gnomeExtensions.appindicator
    # gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.app-icons-taskbar
    # gnomeExtensions.dash-to-dock
    (gnomeExtensions.dash-to-dock.overrideAttrs
      (oldAttrs: rec {
        src = fetchFromGitHub {
          owner = "micheleg";
          repo = "dash-to-dock";
          rev = "fc795c52b7f973eee065547c4d3eb92a6cbada4a";
          sha256 = "sha256-Cds5Fc+rnvoy01GTZBS7qPh8UC9ekrNBOs+IEkDNkJw=";
        };
      }))
    gnomeExtensions.dash-to-panel
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.gnome-clipboard
    gnomeExtensions.clipboard-history
    gnomeExtensions.espresso
    gnomeExtensions.blur-my-shell
    # gnomeExtensions.pop-shell
    gnomeExtensions.proxy-switcher
    gnomeExtensions.gsconnect
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
