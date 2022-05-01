{ config
, pkgs
, lib
, ...
}: {
  # fix tiny cursor at qt-apps
  xsession.pointerCursor = {
    name = "Vanilla-DMZ-AA";
    package = pkgs.vanilla-dmz;
    size = 128;
  };

  # fix spotify hidpi
  xdg.desktopEntries.spotify = lib.mkIf config.services.xserver.desktopManager.gnomeplasma5.enable {
    name = "Spotify";
    genericName = "Music Player";
    icon = "spotify-client";
    exec = "spotify %U --force-device-scale-factor=2";
    terminal = false;
    categories = [ "Application" "Music" ];
  };
}
