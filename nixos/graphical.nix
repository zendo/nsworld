{
  lib,
  pkgs,
  config,
  ...
}:
{
  # Only enable on Desktop
  config = lib.mkIf config.services.graphical-desktop.enable {

    # Graphical Applications
    programs = {
      appimage.enable = true;
    };

    # Bluetooth
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          JustWorksRepairing = "always";
        };
      };
    };

    # Sound
    security.rtkit.enable = config.services.pipewire.enable;
    services.pipewire = {
      # alsa.support32Bit = true;
      # jack.enable = true;
    };

    # Fix xdg-open in FHS sandbox
    xdg.portal.xdgOpenUsePortal = true;

    # Plymouth
    boot = {
      plymouth.enable = true;
      # Silent Boot
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = lib.optionals config.boot.plymouth.enable [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
    };
  };
}
