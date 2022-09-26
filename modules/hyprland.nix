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
    waybar-hyprland
    swappy # screenshot annotation editor
    swaybg # wallpaper tool
    libnotify # notify-send
    swayidle
    # gtklock # still in pr
    swaylock
    swaylock-effects
    wofi # quick run
    wofi-emoji
    wlogout
    wlsunset # nightlight
    wl-clipboard
    wf-recorder
    wl-gammactl
    # clipman
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
    wev # wayland event view
    wlr-randr
    light
    brightnessctl # same like light
    bluetuith
    blueberry

    # cinnamon.nemo
    gnome.nautilus
    gnome.file-roller
    gnome-text-editor
    # gnome.eog
    # gthumb
    libsForQt5.gwenview
    evince
    gparted
    # polkit_gnome

    hyprpaper
    # hyprpicker # color picker
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
    # "/libexec"  # for polkit
  ];

  # environment.etc."polkit-gnome-authentication-agent-1".source = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";

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

  # xdg.portal = { # Required for flatpak with windowmanagers
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };

  home-manager.users.${username} = {pkgs, config, ...}: {
    # xdg.configFile."hypr/hyprland.conf".source = ../dotfiles/hyprland.conf;
    # home.sessionVariables = {
    #   MOZ_ENABLE_WAYLAND = "1";
    #   XDG_SESSION_TYPE = "wayland";
    #   XDG_CURRENT_DESKTOP = "sway";
    # };

    # fix tiny cursor
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
