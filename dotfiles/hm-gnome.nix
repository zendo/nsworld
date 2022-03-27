{
  config,
  pkgs,
  ...
}: {
  # fix tiny cursor in qt-apps @gnome
  xsession.pointerCursor = {
    name = "Vanilla-DMZ-AA";
    package = pkgs.vanilla-dmz;
    size = 128;
  };

  # fix spotify hidpi @gnome
  xdg.desktopEntries.spotify = {
    name = "Spotify";
    genericName = "Music Player";
    icon = "spotify-client";
    exec = "spotify %U --force-device-scale-factor=2";
    terminal = false;
    categories = ["Application" "Music"];
  };

}
