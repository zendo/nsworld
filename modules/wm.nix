{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  services.xserver = {
    # for X11
    enable = true;
    libinput.enable = true;
    xkbOptions = "ctrl:swapcaps";
    # use greetd
    displayManager.lightdm.enable = false;
    displayManager.lightdm.greeters.gtk.extraConfig = ''
      xft-dpi=196
    '';
    excludePackages = [
      pkgs.xterm
    ];
  };

  services.greetd.enable = true;

  environment.systemPackages = with pkgs; [
    # Sway apps
    swappy # screenshot annotation editor
    swaybg # wallpaper tool
    swayidle
    swaylock
    swaylock-effects
    swaynotificationcenter
    # mako  # , notify-send "sth"
    libnotify # notify-send
    wlogout

    eww-wayland

    # wlr apps
    wofi # quick run
    wofi-emoji
    wl-clipboard
    wf-recorder
    cliphist
    networkmanagerapplet
    bluetuith
    blueberry
    wev # wayland event view
    wvkbd # on-screen keyboard
    # waypipe # proxy ?
    # wtype # xdotool

    # Display
    brightnessctl # same like light
    wlsunset # nightlight
    wl-gammactl
    wdisplays
    wlr-randr
    kanshi # autorandr

    # Media
    grim # grab image
    slurp # select region
    wayshot
    pavucontrol
    playerctl # media player control
    pamixer # volume control

    # Needs when use other DM
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra

    gnome.nautilus
    gnome-text-editor
    gnome.gnome-power-manager
    # gnome.eog
    # gthumb
    libsForQt5.gwenview
    gparted
  ];

  programs = {
    light.enable = true;
    gtklock.enable = true;
    evince.enable = true;
    file-roller.enable = true;
    # dconf.enable = true;
  };

  services = {
    gvfs.enable = true;
    upower.enable = true;
    blueman.enable = true;
    geoclue2.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  environment.pathsToLink = [
    "/share/zsh" # for zsh completion with hm
  ];

  # give polkit-gnome a absolute path for exec
  environment.etc = {
    "polkit-gnome-authentication-agent-1".source = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-wlr xdg-desktop-portal-gtk];
  };

  # programs.qt5ct.enable = true;

  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita";
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      # fcitx5-chinese-addons
    ];
  };

  home-manager.users.${username} = {
    pkgs,
    config,
    ...
  }: {
    # xdg.configFile."hypr".source = ../dotfiles/hypr;
    # home.sessionVariables = {
    #   MOZ_ENABLE_WAYLAND = "1";
    #   XDG_SESSION_TYPE = "wayland";
    #   XDG_CURRENT_DESKTOP = "sway";
    # };

    # Fix tiny cursor
    home.pointerCursor = {
      name = "Vanilla-DMZ-AA";
      package = pkgs.vanilla-dmz;
      size = 128;
      # name = "Bibata-Modern-Classic";
      # package = pkgs.bibata-cursors;
      # size = 128;
    };

    home.packages = with pkgs; [
    ];

    services = {
      udiskie.enable = true;
      poweralertd.enable = true;
      #   playerctld.enable = true;
      #   easyeffects.enable = true;
    };
  };
}
