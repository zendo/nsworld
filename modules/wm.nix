{
  config,
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
  };

  environment.systemPackages = with pkgs; [
    # Sway apps
    swappy # screenshot annotation editor
    swaybg # wallpaper tool
    swayidle
    # gtklock # still in pr
    swaylock
    swaylock-effects
    swaynotificationcenter
    # mako  # , notify-send "sth"
    wlogout

    # wlr apps
    wofi # quick run
    wofi-emoji
    wl-clipboard
    wf-recorder
    cliphist
    libnotify # notify-send
    networkmanagerapplet
    bluetuith
    blueberry
    wev # wayland event view
    wvkbd # on-screen keyboard

    # autotiling # https://github.com/nwg-piotr/autotiling

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
    pavucontrol
    playerctl # media player control
    pamixer # volume control

    # cinnamon.nemo
    gnome.nautilus
    gnome.file-roller
    gnome-text-editor
    # gnome.eog
    # gthumb
    libsForQt5.gwenview
    evince
    gparted
  ];

  programs = {
    light.enable = true;
  };

  services = {
    gvfs.enable = true;
    upower.enable = true;
    blueman.enable = true;
    geoclue2.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  security.polkit.enable = true;
  security.pam.services.swaylock = {};

  environment.pathsToLink = [
    "/share/zsh" # for zsh completion with hm
  ];

  # give polkit-gnome a absolute path for exec
  environment.etc = {
    "polkit-gnome-authentication-agent-1".source = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  # Required for flatpak and gtk apps in WM
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
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
    };

    home.packages = with pkgs; [
      yafetch
      freshfetch
    ];

    #   systemd.user.services.polkit-gnome = {
    #   Unit = {
    #     Description = "PolicyKit Authentication Agent";
    #     After = [ "graphical-session-pre.target" ];
    #     PartOf = [ "graphical-session.target" ];
    #   };

    #   Service = {
    #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #   };

    #   Install = {
    #     WantedBy = [ "graphical-session.target" ];
    #   };
    # };
  };
}
