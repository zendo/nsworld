# https://github.com/NixOS/nixos-hardware/blob/master/dell/xps/sleep-resume/i2c-designware/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  reloadDesignware = pkgs.writeShellApplication {
    name = "reload-hid-multitouch.sh";
    runtimeInputs = [ pkgs.kmod ];
    text = ''
      # Reload the hid-multitouch driver after resuming from sleep.
      # for host#yoga

      # Wait up-to 0.5 second for each module to be unloaded:
      # (It should never take this long)
      modprobe -r --wait 500 hid-multitouch

      # Should reload the module dependencies automatically:
      modprobe hid-multitouch
    '';
  };

  cfg = config.services.sleep-resume.hid-multitouch;
in
{
  options.services.sleep-resume.hid-multitouch = {
    enable = lib.mkEnableOption "Reload the hid-multitouch driver after resuming from sleep.";
  };

  config = lib.mkIf cfg.enable {
    powerManagement.resumeCommands = "${reloadDesignware}/bin/reload-hid-multitouch.sh";
  };
}
