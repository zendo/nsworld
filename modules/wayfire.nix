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

    displayManager = {
      # sddm.enable = true;
      # lightdm.enable = true;
      # defaultSession = "wayfire";
    };
  };

  environment.systemPackages = with pkgs; [
    wayfire
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
    clipman
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
    gnome.nautilus
    brightnessctl
  ];

  environment.pathsToLink = [
    "/share/zsh" # for zsh completion
  ];

  # environment.sessionVariables.XCURSOR_SIZE = lib.mkForce "80";
  # CLUTTER_BACKEND = "wayland";
  # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  # MOZ_ENABLE_WAYLAND = "1";
  # QT_QPA_PLATFORM = "wayland;xcb";

  security.polkit.enable = true;
  security.pam.services.swaylock = {};

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
    home.packages = with pkgs; [
      yafetch
      freshfetch
    ];
  };
}
