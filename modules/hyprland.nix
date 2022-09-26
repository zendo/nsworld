{ config
, pkgs
, ...
}: {
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  services.xserver = {
    enable = true;
    excludePackages = [
      pkgs.xterm
    ];

    displayManager = {
      # gdm.enable = true;
      lightdm.enable = true;
      # defaultSession = "plasmawayland";
    };
  };

  environment.systemPackages = with pkgs; [
    swappy
    swaybg # wallpaper tool
    swayidle
    swaylock
    swaylock-effects
    waybar # status bar
    wofi
    rofi
    bemenu
    wlsunset
    wl-clipboard
    wf-recorder
    mako
    grim # grab image
    slurp # select region
    xfce.thunar
    gnome.nautilus
    viewnior
    eww
    dunst
    # hyprpicker # color picker
  ];

  # environment.sessionVariables = {
  #   CLUTTER_BACKEND = "wayland";
  #   XDG_SESSION_TYPE = "wayland";
  #   QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  #   MOZ_ENABLE_WAYLAND = "1";
  #   QT_QPA_PLATFORM = "wayland;xcb";
  #   GDK_BACKEND = "wayland";
  #   _JAVA_AWT_WM_NONREPARENTING = "1";
  #   XCURSOR_SIZE = "24";
  #   NIXOS_OZONE_WL = "1";
  # };

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
