let
  music = "audacious.desktop";
  browser = "firefox.desktop";

  gtk-image = "org.gnome.Loupe.desktop";
  gtk-editor = "org.gnome.TextEditor.desktop";

  qt-image = "org.kde.gwenview.desktop";
  qt-editor = "org.kde.kwrite.desktop";
in
{
  flake.modules.nixos.mime =
    { lib, config, ... }:
    {
      # https://www.iana.org/assignments/media-types/media-types.xhtml
      xdg.mime = {
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
          (lib.mkIf config.services.desktopManager.gnome.enable {
            "text/plain" = gtk-editor;
            "text/markdown" = gtk-editor;
          })
          (lib.mkIf config.services.desktopManager.plasma6.enable {
            "image/jpeg" = qt-image;
            "image/png" = qt-image;
            "image/webp" = qt-image;

            "text/plain" = qt-editor;
            "text/markdown" = qt-editor;

            "application/pdf" = "org.kde.okular.desktop";
          })
        ];
      };
    };

  # flake.modules.homeManager.mime =
  #   { lib, ... }:
  #   {
  #     xdg.mimeApps = {
  #       enable = true;
  #       defaultApplications = lib.mkMerge [ ];
  #     };
  #   };

  # flake.modules.hjem.mime = {
  #   xdg.mime-apps.default-applications = { };
  # };
}
