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
    hardware.bluetooth = {
      enable = true;
    };

    # Sound
    security.rtkit.enable = config.services.pipewire.enable;
    services.pipewire = {
      # alsa.support32Bit = true;
      # jack.enable = true;
    };

    # Fix xdg-open in FHS sandbox
    xdg.portal.xdgOpenUsePortal = true;
  };
}
