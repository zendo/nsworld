{
  config,
  pkgs,
  ...
}: {
  # fix tiny cursor at qt-apps
  home.file.".icons/default/index.theme".text = ''
    [icon theme]
    Inherits=Adwaita
  '';

  # fix spotify hidpi
  xdg.desktopEntries.spotify = {
    name = "Spotify";
    genericName = "Music Player";
    icon = "spotify-client";
    exec = "spotify %U --force-device-scale-factor=2";
    terminal = false;
    categories = ["Application" "Music"];
  };

  # home.packages = with pkgs; [
  #   (spotify.override {
  #     deviceScaleFactor = 2;
  #   })
  # ];
}
