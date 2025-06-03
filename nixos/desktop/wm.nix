{
  pkgs,
  lib,
  config,
  ...
}:
{
  mods.fcitx.enable = true;

  security = {
    soteria.enable = true; # Polkit agent
  };

  services = {
    gvfs.enable = true; # (webkitgtk)
    upower.enable = true;
    blueman.enable = true;
    geoclue2.enable = true;

    # https://github.com/apognu/tuigreet/issues/145
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = lib.concatStringsSep " " [
            "${pkgs.greetd.tuigreet}/bin/tuigreet"
            "--time"
            "--asterisks"
            "--remember"
            "--remember-session"
            "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
          ];
        };
      };
    };
  };

  programs = {
    light.enable = true;
    file-roller.enable = true;

    evince = {
      enable = true;
      package = pkgs.papers;
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  environment.pathsToLink = [
    "/share"
    "/share/fcitx5" # for fxitx theme
  ];

  environment.sessionVariables = {
    # GDK_BACKEND = "wayland";
    # WLR_DRM_NO_ATOMIC = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      {
        home.packages = with pkgs; [
          swappy # screenshot annotation editor
          swaybg # wallpaper tool
          swaylock-effects
          hyprlock
          # mako  # , notify-send "sth"
          libnotify # notify-send
          swayidle
          wlogout
          waybar
          uwsm
          xwayland-satellite

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
          wl-gammactl
          wdisplays
          wlr-randr
          wlsunset

          # Media
          # grim # grab image
          # slurp # select region
          shotman
          # pavucontrol
          pwvucontrol # Pipewire Volume Control
          playerctl # media player control
          pamixer # volume control

          # Needs when use other DM
          adwaita-icon-theme
          gnome-themes-extra
          dconf-editor
          gnome-tweaks # (webkitgtk)

          xfce.mousepad
          nomacs
          loupe
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
          swaync.enable = true; # notification center

          # kanshi alternative
          # way-displays = {
          #   enable = true;
          # };

          # https://wiki.archlinux.org/title/Kanshi
          kanshi = {
            enable = true;
          };

          wlsunset = {
            enable = true;
            # gama = "2.0";
            latitude = "22.2783";
            longitude = "114.1747";
            temperature.night = 3000; # default: 4000
          };
        };

        # Dark Mode
        dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

        qt = {
          enable = true;
          platformTheme.name = "adwaita";
          style.name = "adwaita";
          style.package = pkgs.adwaita-qt;
        };
      }
    )
  ];
}
