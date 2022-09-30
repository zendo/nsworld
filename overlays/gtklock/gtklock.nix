{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.gtklock;

in
{
  options = {
    programs.gtklock = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to install Light backlight control command
          and udev rules granting access to members of the "video" group.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gtklock ];
    # services.udev.packages = [ pkgs.light ];
    security.pam.services.gtklock = {};
  };
}
