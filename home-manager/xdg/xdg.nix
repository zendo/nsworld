{
  lib,
  pkgs,
  config,
  nixosConfig,
  ...
}:
{
  home.sessionPath = [
    "${../../dotfiles/bin}"
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient -c -a emacs";
    VISUAL = "micro";
    NIXOS_OZONE_WL = lib.mkDefault 1; # Electron wayland native
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    autostart = {
      enable = true;
      readOnly = true;
      entries = [
        # "${pkgs.goodvibes}/share/applications/io.gitlab.Goodvibes.desktop"
      ];
    };

    dataFile = {
      # Fix qt tiny cursor on gnome
      "icons/default/index.theme".text = ''
        [icon theme]
        Inherits=Adwaita
      '';
    };

    # https://www.iana.org/assignments/media-types/media-types.xhtml
    mimeApps = {
      enable = true;
      defaultApplications = lib.mkMerge [
        {
          "audio/mpeg" = "audacious.desktop";
          "audio/flac" = "audacious.desktop";
          "audio/x-vorbis+ogg" = "audacious.desktop";
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "image/jpeg" = "org.gnome.Loupe.desktop";
          "image/png" = "org.gnome.Loupe.desktop";
          "image/webp" = "org.gnome.Loupe.desktop";
        }
        (lib.mkIf nixosConfig.services.desktopManager.gnome.enable {
          "text/plain" = "org.gnome.TextEditor.desktop";
          "application/pdf" = "org.gnome.Papers.desktop";
        })
        (lib.mkIf nixosConfig.services.desktopManager.plasma6.enable {
          "image/jpeg" = "org.kde.gwenview.desktop";
          "image/png" = "org.kde.gwenview.desktop";
          "image/webp" = "org.kde.gwenview.desktop";
          "text/plain" = "org.kde.kwrite.desktop";
          "application/pdf" = "org.kde.okular.desktop";
        })
        # for wm
        (lib.mkIf config.services.wlsunset.enable {
          "text/plain" = "org.gnome.TextEditor.desktop";
          "application/pdf" = "org.gnome.Papers.desktop";
        })
      ];
    };

    # Cursor Theme
    # home.pointerCursor = {
    #   name = "Vanilla-DMZ-AA";
    #   package = pkgs.vanilla-dmz;
    #   size = 128;
    #   # name = "Bibata-Modern-Classic";
    #   # package = pkgs.bibata-cursors;
    #   # size = 128;
    # };

    desktopEntries = {
      #   spotify = {
      #     name = "Spotify";
      #     genericName = "Music Player";
      #     icon = "spotify-client";
      #     exec = "env NIXOS_OZONE_WL= spotify %U --force-device-scale-factor=2";
      #     terminal = false;
      #     categories = ["Application" "Music"];
      #   };
      # code = {
      #   name = "Visual Studio Code";
      #   icon = "vscode";
      #   exec = "env NIXOS_OZONE_WL= code";
      # };
      # doom-emacs = {
      #   name = "Doom Emacs";
      #   icon = "${../dotfiles/emacs/doom-emacs.svg}";
      #   exec = ''sh -c "emacs --init-directory ${config.home.homeDirectory}/.config/doom-emacs"'';
      # };
    };
  };
}
