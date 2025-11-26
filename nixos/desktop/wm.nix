{
  lib,
  pkgs,
  self,
  config,
  ...
}:
{
  security = {
    soteria.enable = true; # Polkit agent
    pam.services.hyprlock = { };
  };

  services = {
    gvfs.enable = true; # (webkitgtk)
    upower.enable = true;
    geoclue2.enable = true;

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

  # =========================================================================
  #  Home-manager
  # =========================================================================
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        imports = [
          (self + /home-manager/xdg/noctalia.nix)
        ];

        home.packages = with pkgs; [
          libnotify # notify-send
          hyprlock
          swaylock-effects
          stasis # idle manager
          wlogout
          fuzzel
          bemoji
          wl-clipboard
          wf-recorder
          cliphist
          blueberry
          uwsm
          xwayland-satellite
          wlopm
          wev # wayland event view
          wvkbd # on-screen keyboard
          # waypipe # proxy ?
          # wtype # xdotool

          # Display
          avizo # lightctl / volumectl
          wlsunset
          brightnessctl # same like light
          wl-gammactl
          wdisplays
          shikane
          wlr-randr

          # Media
          # grim # grab image
          # slurp # select region
          shotman
          nomacs
          hyprpicker
          # pavucontrol
          pwvucontrol # Pipewire Volume Control
          playerctl # media player control
          pamixer # volume control

          # Needs when use other DM
          adwaita-icon-theme
          gnome-themes-extra
          dconf-editor
          glib.bin # gsettings

          loupe
          papers
          # file-roller
          xarchiver
          swappy # screenshot annotation editor
          # gnome.gnome-power-manager
          # gnome.gnome-characters
          # gthumb
          # kdePackages.gwenview
          gparted
        ];

        services = {
          # network-manager-applet.enable = true;
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

          hypridle = {
            # enable = true;
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
