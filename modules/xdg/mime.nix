let
  app-music = "audacious.desktop";
  app-browser = "firefox.desktop";

  gtk-image = "org.gnome.Loupe.desktop";
  gtk-editor = "org.gnome.TextEditor.desktop";

  qt-image = "org.kde.gwenview.desktop";
  qt-editor = "org.kde.kwrite.desktop";

  commonDefaults = {
    "audio/mpeg" = app-music;
    "audio/flac" = app-music;
    "audio/x-vorbis+ogg" = app-music;

    "text/html" = app-browser;
    "x-scheme-handler/http" = app-browser;
    "x-scheme-handler/https" = app-browser;

    "image/jpeg" = gtk-image;
    "image/png" = gtk-image;
    "image/webp" = gtk-image;

    "application/pdf" = "org.gnome.Papers.desktop";
  };

  gnomeOverrides = {
    "text/plain" = gtk-editor;
    "text/markdown" = gtk-editor;
  };

  plasmaOverrides = {
    "text/plain" = qt-editor;
    "text/markdown" = qt-editor;

    "image/jpeg" = qt-image;
    "image/png" = qt-image;
    "image/webp" = qt-image;

    "application/pdf" = "org.kde.okular.desktop";
  };
in
{
  flake.modules.nixos.mime =
    { lib, config, ... }:
    {
      # https://www.iana.org/assignments/media-types/media-types.xhtml
      xdg.mime = {
        enable = true;
        defaultApplications = lib.mkMerge [
          commonDefaults
          (lib.mkIf config.services.desktopManager.gnome.enable gnomeOverrides)
          (lib.mkIf config.services.desktopManager.plasma6.enable plasmaOverrides)
        ];
      };
    };
}
