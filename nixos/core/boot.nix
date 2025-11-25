{ lib, config, ... }:
{
  boot = {
    # enable systemd in initrd
    initrd.systemd = {
      enable = lib.mkDefault true;
    };

    # /tmp
    tmp = {
      useTmpfs = lib.mkDefault true;
      cleanOnBoot = lib.mkDefault true;
    };

    # Plymouth
    plymouth.enable = config.services.graphical-desktop.enable;
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

  # Perlless Activation
  # system.etc.overlay.enable = true;

  # Bashless Activation
  # https://github.com/NixOS/nixpkgs/issues/428908
  # system.nixos-init.enable = true;
}
