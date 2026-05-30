{
  flake.modules.nixos.boot =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      # Perlless Activation
      system.etc.overlay.enable = true;
      # Bashless Activation
      system.nixos-init.enable = true;

      # https://github.com/hakavlad/nohang
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/no/nohang/package.nix
      # FIXME: hardcode sudo
      systemd.oomd.enable = false;
      services.nohang.enable = true;

      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

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
    };
}
