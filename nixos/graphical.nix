{
  lib,
  pkgs,
  config,
  ...
}:
{
  # Only enable on Desktop
  config = lib.mkIf config.services.graphical-desktop.enable {

    # Bluetooth
    hardware.bluetooth.enable = true;

    # Sound
    security.rtkit.enable = config.services.pipewire.enable;
    services.pipewire = {
      # alsa.support32Bit = true;
      # jack.enable = true;
    };

    # Graphical Applications
    programs = {
      appimage.enable = true;

      clash-verge = {
        # enable = true;
        # autoStart = true;
      };
    };
  };
}
