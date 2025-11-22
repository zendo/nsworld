{
  lib,
  config,
  nixosConfig,
  ...
}:
{
  # https://www.iana.org/assignments/media-types/media-types.xhtml
  xdg.mimeApps = {
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
}
