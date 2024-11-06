{ pkgs, username, ... }:
{
  mods.fcitx.enable = true;

  services = {
    xserver.displayManager.lightdm = {
      enable = false; # greetd instaed
      greeters.gtk = {
        cursorTheme.size = 48;
        extraConfig = ''
          xft-dpi=261
          clock-format=%H:%M
        '';
        indicators = [
          "~spacer"
          "~clock"
          "~spacer"
          "~session"
          # "~language"
          # "~a11y"
          "~power"
        ];
      };
    };

    gvfs.enable = true; # (webkitgtk)
    upower.enable = true;
    blueman.enable = true;
    geoclue2.enable = true;
  };

  programs = {
    light.enable = true;
    # gtklock.enable = true;
    evince.enable = true;
    file-roller.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  # If using wm@hm
  security.pam.services.swaylock = { };
  programs.dconf.enable = true;
  programs.xwayland.enable = true;

  environment.pathsToLink = [
    "/share"
    "/share/fcitx5" # for fxitx theme
  ];

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    # GDK_BACKEND = "wayland";
    # WLR_DRM_NO_ATOMIC = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # systemctl --user show-environment
  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  home-manager.users.${username} =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        swappy # screenshot annotation editor
        swaybg # wallpaper tool
        swaylock-effects
        # mako  # , notify-send "sth"
        libnotify # notify-send
        swayidle
        wlogout
        waybar

        wofi # quick run
        wofi-emoji
        wl-clipboard
        wf-recorder
        cliphist
        networkmanagerapplet
        bluetuith
        blueberry
        wlopm
        wev # wayland event view
        wvkbd # on-screen keyboard
        # waypipe # proxy ?
        # wtype # xdotool

        # Display
        brightnessctl # same like light
        wlsunset # nightlight for manually control
        wl-gammactl
        wdisplays
        wlr-randr
        kanshi # autorandr

        # Media
        # grim # grab image
        # slurp # select region
        shotman
        pavucontrol
        playerctl # media player control
        pamixer # volume control

        # Needs when use other DM
        adwaita-icon-theme
        gnome-themes-extra
        dconf-editor
        gnome-tweaks # (webkitgtk)

        xfce.mousepad
        nomacs
        # gnome.gnome-power-manager
        # gnome.gnome-characters
        # gthumb
        # kdePackages.gwenview
        gparted
      ];

      services = {
        avizo.enable = true;
        udiskie.enable = true;
        gnome-keyring.enable = true;
        # playerctld.enable = true;
        polkit.enable = true;
        swaync.enable = true; # notification center

        wlsunset = {
          enable = true;
          # gama = "2.0";
          latitude = "22.2783";
          longitude = "114.1747";
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "adwaita";
        style.name = "adwaita";
        style.package = pkgs.adwaita-qt;
      };
    };
}
