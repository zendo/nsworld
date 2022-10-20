{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.wob;

in {
  meta.maintainers = [ hm.maintainers.zendo ];

  options.services.wob = {
    enable = mkEnableOption "wob";

    package = mkOption {
      type = types.package;
      default = pkgs.wob;
      defaultText = "pkgs.wob";
      description = ''
        wob derivation to use.
      '';
    };
  };

  config = mkIf cfg.enable {

    systemd.user.services.wob = {
      Unit = {
        Description = "A lightweight overlay volume/backlight/progress/anything bar for Wayland";
        PartOf = [ "graphical-session.target" ];
        After = ["graphical-session-pre.target"];
        ConditionPathExistsGlob = ["%t/wayland-*"];
      };

      Install.WantedBy = ["graphical-session.target"];

      Service = {
        ExecStart = "${pkgs.wob}/bin/wob";
        StandardInput = "socket";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    systemd.user.sockets.wob = {
      Socket = {
        ListenFIFO = "%t/wob.sock";
        SocketMode = 0600;
        ConditionPathExistsGlob = ["%t/wayland-*"];
      };

      Install.WantedBy = ["sockets.target" "graphical-session.target"];
    };
  };
}
