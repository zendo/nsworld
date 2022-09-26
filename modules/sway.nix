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

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    # extraSessionCommands = ''
    # '';
    extraPackages = with pkgs; [
      swappy # screenshot annotation editor
      swaybg # wallpaper tool
      libnotify # notify-send
      swayidle
      swaylock
      swaylock-effects
      waybar # status bar
      wofi # quick run
      wofi-emoji
      wlogout
      wlsunset # nightlight
      wl-clipboard
      wf-recorder
      wl-gammactl
      cliphist
      swaynotificationcenter
      mako  # , notify-send "sth"
      grim # grab image
      slurp # select region
      pavucontrol
      playerctl # media player control
      pamixer # volume control
      networkmanagerapplet
      kanshi # autorandr
      autotiling # https://github.com/nwg-piotr/autotiling
      wdisplays
      brightnessctl
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
  };

  services = {
    gvfs.enable = true;
    upower.enable = true;
    geoclue2.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  qt5 = {
    enable =  true;
    platformTheme = "gnome";
    style = "adwaita";
  };

  # programs.qt5ct.enable = true;

  environment.systemPackages = with pkgs; [
  ];

  environment.pathsToLink = [
    "/share/zsh" # for zsh completion with hm
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.enableRimeData= true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      # fcitx5-chinese-addons
    ];
  };

  home-manager.users.${username} = {pkgs, config, ...}: {
  #   # xdg.configFile."hypr/hyprland.conf".source = ../dotfiles/hyprland.conf;
  #   # home.sessionVariables = {
  #   #   MOZ_ENABLE_WAYLAND = "1";
  #   #   XDG_SESSION_TYPE = "wayland";
  #   #   XDG_CURRENT_DESKTOP = "sway";
  #   # };

  #   # fix tiny cursor
    home.pointerCursor = {
      name = "Vanilla-DMZ-AA";
      package = pkgs.vanilla-dmz;
      size = 128;
    };

  #   home.packages = with pkgs; [
  #     yafetch
  #     freshfetch
  #   ];
  };
}
