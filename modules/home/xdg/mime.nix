{
  lib,
  nixosConfig,
  ...
}:
let
  music = "audacious.desktop";
  browser = "firefox.desktop";
  gtk-image = "org.gnome.Loupe.desktop";
  qt-image = "org.kde.gwenview.desktop";
in
{
  # https://www.iana.org/assignments/media-types/media-types.xhtml
  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.mkMerge [
      {
        "audio/mpeg" = music;
        "audio/flac" = music;
        "audio/x-vorbis+ogg" = music;

        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;

        "image/jpeg" = gtk-image;
        "image/png" = gtk-image;
        "image/webp" = gtk-image;

        "application/pdf" = "org.gnome.Papers.desktop";
      }
      (lib.mkIf nixosConfig.services.desktopManager.gnome.enable {
        "text/plain" = "org.gnome.TextEditor.desktop";
      })
      (lib.mkIf nixosConfig.services.desktopManager.plasma6.enable {
        "image/jpeg" = qt-image;
        "image/png" = qt-image;
        "image/webp" = qt-image;

        "text/plain" = "org.kde.kwrite.desktop";
        "application/pdf" = "org.kde.okular.desktop";
      })
    ];
  };
}
