{
  lib,
  pkgs,
  config,
  ...
}:
{
  # Only enable on Desktop
  config = lib.mkIf config.services.graphical-desktop.enable {

    hardware.bluetooth.enable = true;

    programs = {
      appimage.enable = true;

      clash-verge = {
        # enable = true;
        # autoStart = true;
      };
    };
  };
}
