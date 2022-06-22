# wip
{
  pkgs,
  lib,
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
      # defaultSession = "plasmawayland";
      # autoLogin.user = "${username}";
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      swappy
      swaylock-effects # lockscreen
      waybar # status bar
      kanshi # autorandr
      dunst # notification daemon
      autotiling # https://github.com/nwg-piotr/autotiling
      wl-clipboard
      wdisplays
      wofi
      mako
      dex
      pavucontrol
      networkmanagerapplet
    ];
  };

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    extraPortals = with pkgs; [xdg-desktop-portal-wlr xdg-desktop-portal-gtk];
  };
  # xdg.portal.enable = true;
  # xdg.portal.wlr.enable = true;

  # programs.qt5ct.enable = true;

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  environment.systemPackages = with pkgs; [
    xdg_utils
    # polkit agent
    polkit_gnome
    # screen brightness
    brightnessctl
  ];

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
