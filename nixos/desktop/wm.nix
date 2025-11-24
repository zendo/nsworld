{
  pkgs,
  lib,
  config,
  ...
}:
{
  security = {
    soteria.enable = true; # Polkit agent
    pam.services.swaylock = { };
    pam.services.hyprlock = { };
  };

  services = {
    gvfs.enable = true; # (webkitgtk)
    upower.enable = true;
    blueman.enable = true;
    geoclue2.enable = true;
    hypridle.enable = true;

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = lib.concatStringsSep " " [
            "${lib.getExe pkgs.tuigreet}"
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
      { pkgs, ... }:
      {
        imports = [
          ../../home-manager/xdg/noctalia.nix
        ];

        home.packages = with pkgs; [
          swappy # screenshot annotation editor
          swaybg # wallpaper tool
          waypaper
          swaylock-effects
          hyprlock
          libnotify # notify-send
          # TODO: idle manager
          # https://saltnpepper97.github.io/stasis/configuration
          stasis
          swayidle
          wlogout
          uwsm

          fuzzel
          bemoji
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
          file-roller
          papers

          # Display
          brightnessctl # same like light
          wl-gammactl
          wdisplays
          shikane
          wlr-randr

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

          nomacs
          loupe
          hyprpicker
          # gnome.gnome-power-manager
          # gnome.gnome-characters
          # gthumb
          # kdePackages.gwenview
          gparted
        ];

        services = {
          # playerctld.enable = true;

          # wdisplays set the right outputs
          # install -Dm644 /dev/null ~/.config/shikane/config.toml
          # shikane
          # shikanectl export "host"
          shikane = {
            enable = true;
          };

          cliphist = {
            enable = true;
            allowImages = true;
          };
        };

        # qt = {
        #   enable = true;
        #   platformTheme.name = "adwaita";
        #   style.name = "adwaita";
        #   style.package = pkgs.adwaita-qt;
        # };

        xdg.dataFile = {
          # Fix qt tiny cursor on gnome
          "icons/default/index.theme".text = ''
            [icon theme]
            Inherits=Adwaita
          '';
        };
      }
    )
  ];
}
