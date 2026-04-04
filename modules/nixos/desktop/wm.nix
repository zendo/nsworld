{ inputs, ... }:
{
  flake.modules.nixos.wm =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        dms
        greetd
        # ly
      ];

      home-manager.sharedModules = [ inputs.self.modules.homeManager.wm ];

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

      programs.thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-archive-plugin
          thunar-volman
        ];
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
    };

  # ╭─────────────────────────────────────────────────────╮
  # │  Home-manager                                       │
  # ╰─────────────────────────────────────────────────────╯
  flake.modules.homeManager.wm =
    { pkgs, ... }:
    {
      imports = [
        inputs.self.modules.homeManager.hypridle
        inputs.self.modules.homeManager.shikane
      ];

      home.packages = with pkgs; [
        libnotify # notify-send
        wlogout
        swayidle
        hypridle
        hyprlock
        stasis # idle manager
        wf-recorder
        uwsm
        xwayland-satellite
        wev # wayland event view
        # waypipe # proxy ?
        # wtype # xdotool

        # Display
        avizo # lightctl / volumectl
        brightnessctl
        wlsunset
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
    };

  # ╭──────────────────────────────────────────╮
  # │ SWAY                                     │
  # ╰──────────────────────────────────────────╯
  flake.modules.nixos.sway =
    { pkgs, ... }:
    {
      imports = [ inputs.self.modules.nixos.wm ];
      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraPackages = [
          pkgs.autotiling-rs
        ];
      };
    };

  # ╭──────────────────────────────────────────╮
  # │ HYPRLAND                                 │
  # ╰──────────────────────────────────────────╯
  flake.modules.nixos.hyprland =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.wm ];
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
    };

  # ╭──────────────────────────────────────────╮
  # │ NIRI                                     │
  # ╰──────────────────────────────────────────╯
  flake.modules.nixos.niri =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.wm ];
      programs.niri.enable = true;
      services.displayManager.dms-greeter.compositor.name = "niri";
    };

  # ╭──────────────────────────────────────────╮
  # │ GREETD                                   │
  # ╰──────────────────────────────────────────╯
  flake.modules.nixos.greetd =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings = {
          default_session = {
            command = ''
              ${lib.getExe pkgs.tuigreet} \
              --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions \
              --time \
              --time-format '%Y-%m-%d %H:%M' \
              --asterisks \
              --remember \
              --remember-session
            '';
          };
        };
      };
    };

  # ╭──────────────────────────────────────────╮
  # │ LY                                       │
  # ╰──────────────────────────────────────────╯
  flake.modules.nixos.ly =
    { ... }:
    {
      services.displayManager.ly = {
        enable = true;
        # https://codeberg.org/fairyglade/ly/src/branch/master/res/config.ini
        settings = {
          animation = "matrix";
          bigclock = true;
          session_log = null;
          clear_password = true;
          hide_version_string = true;
        };
      };
    };

  # ╭──────────────────────────────────────────╮
  # │ DMS                                      │
  # ╰──────────────────────────────────────────╯
  flake.modules.nixos.dms =
    { ... }:
    {
      programs.dms-shell = {
        enable = true;
      };

      # include fonts:
      # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/display-managers/dms-greeter.nix#L210
      services.displayManager.dms-greeter = {
        # enable = true;
      };

      # programs.dsearch.enable = true;
    };
}
