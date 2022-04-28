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

  services.xserver.excludePackages = [
    pkgs.xterm
  ];

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
    # notejot
    # lollypop
    rhythmbox
    gparted
    dconf2nix
    kooha
    # fractal

    gnome.gnome-tweaks
    gnome.dconf-editor
    gnome.gnome-power-manager
    gnome.gnome-sound-recorder
    gnome.gnome-boxes
    # gnome-builder
    # gnome-firmware-updater

    gnomeExtensions.appindicator
    gnomeExtensions.tray-icons-reloaded
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
      libpinyin
      typing-booster
    ];
  };
}
