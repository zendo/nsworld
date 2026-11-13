{
  flake.modules.nixos.boot =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      system.etc.overlay.enable = true; # Perlless Activation
      system.nixos-init.enable = true; # Bashless Activation

      # PSI: cat /proc/pressure/memory
      systemd.oomd = {
        enable = true;
        enableUserSlices = true;
      };
      # systemd.oomd.enable = false;
      # services.earlyoom.enable = true;
      # services.nohang.enable = true;

      # No Plymouth
      services.bootvine.enable = true;
      # boot.consoleLogLevel = 3;

      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

        # /tmp
        tmp = {
          useTmpfs = lib.mkDefault true;
          cleanOnBoot = lib.mkDefault true;
        };

        # plymouth.enable = config.services.graphical-desktop.enable;
        # consoleLogLevel = 0; # Silent Boot
        # kernelParams = lib.optionals config.boot.plymouth.enable [
        #   "quiet"
        #   "splash"
        #   "boot.shell_on_fail"
        #   "rd.systemd.show_status=false"
        #   "rd.udev.log_level=3"
        #   "udev.log_priority=3"
        # ];

      };
    };
}
