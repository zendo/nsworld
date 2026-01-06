{ pkgs, ... }:
{
  imports = [
    ./dms.nix
    ./greetd.nix
    # ./ly.nix  # systemd 加载有问题
  ];

  security = {
    soteria.enable = true; # Polkit agent
    pam.services.hyprlock = { };
  };

  services = {
    gvfs.enable = true; # (webkitgtk)
    upower.enable = true;
    geoclue2.enable = true;
    tumbler.enable = true; # thumbnailer service
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
          # ../../home/wm/fuzzel.nix
          ../../home/wm/hypridle.nix
          ../../home/wm/shikane.nix
        ];

        home.packages = with pkgs; [
          libnotify # notify-send
          wlogout
          swayidle
          hypridle
          hyprlock
          stasis # idle manager
          wf-recorder
          blueberry
          uwsm
          xwayland-satellite
          wev # wayland event view
          # waypipe # proxy ?
          # wtype # xdotool

          # Display
          avizo # lightctl / volumectl
          wlsunset
          brightnessctl # same like light
          wl-gammactl
          wlr-randr

          # Media
          # grim # grab image
          # slurp # select region
          nomacs
          # pavucontrol
          pwvucontrol # Pipewire Volume Control
          playerctl # media player control
          pamixer # volume control

          # Needs when use other DM
          adwaita-icon-theme
          gnome-themes-extra
          glib.dev # gsettings
          dconf-editor

          loupe
          papers
          # file-roller
          xarchiver
          # gnome.gnome-power-manager
          # gnome.gnome-characters
          # gthumb
          # kdePackages.gwenview
          gparted
        ];

        services = {
          # network-manager-applet.enable = true;
          # playerctld.enable = true;

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
          # Fix tiny cursor on qt apps
          "icons/default/index.theme".text = ''
            [icon theme]
            Inherits=Adwaita
          '';
        };
      }
    )
  ];
}
