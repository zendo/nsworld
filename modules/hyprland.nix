{
  config,
  pkgs,
  lib,
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  programs.hyprland.enable = true;

  services.xserver = {
    enable = true;
    excludePackages = [
      pkgs.xterm
    ];
  };

  environment.systemPackages = with pkgs; [
    # Hypr
    waybar-hyprland
    # hyprpaper # wallpaper
    # hyprpicker # color picker

    # Sway
    swappy # screenshot annotation editor
    swaybg # wallpaper tool
    swayidle
    # gtklock # still in pr
    swaylock
    swaylock-effects
    swaynotificationcenter
    # mako  # , notify-send "sth"
    wlogout

    # waybar
    wofi # quick run
    wofi-emoji
    wl-clipboard
    wf-recorder
    cliphist
    libnotify # notify-send

    networkmanagerapplet
    kanshi # autorandr
    autotiling # https://github.com/nwg-piotr/autotiling
    bluetuith
    blueberry

    # Display
    light
    brightnessctl # same like light
    wlsunset # nightlight
    wl-gammactl
    wdisplays

    # cinnamon.nemo
    gnome.nautilus
    gnome.file-roller
    gnome-text-editor
    # gnome.eog
    # gthumb
    libsForQt5.gwenview
    evince
    gparted

    # Media
    grim # grab image
    slurp # select region
    pavucontrol
    playerctl # media player control
    pamixer # volume control

    # wlr tools
    wev # wayland event view
    wlr-randr
  ];

  services = {
    gvfs.enable = true;
    upower.enable = true;
    blueman.enable = true;
    geoclue2.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  qt5 = {
    enable =  true;
    platformTheme = "gnome";
    style = "adwaita";
  };

  environment.pathsToLink = [
    "/share/zsh" # for zsh completion with hm
  ];

  security.polkit.enable = true;
  security.pam.services.swaylock = {};

  # Required for flatpak with windowmanagers
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.enableRimeData= true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      # fcitx5-chinese-addons
    ];
  };

  home-manager.users.${username} = {pkgs, config, ...}: {
    # xdg.configFile."hypr/hyprland.conf".source = ../dotfiles/hyprland.conf;
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

    # systemd.user.services.polkit-gnome = {
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
