{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.wob;

in {
  meta.maintainers = [ maintainers.zendo ];

  options.services.wob = {
    enable = mkEnableOption "Wayland Overlay Bar";
  };

  config = mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.playerctld" pkgs
      lib.platforms.linux)
    ];

    systemd.user.services.wob = {
      Unit = {
        Description = "A lightweight overlay volume/backlight/progress/anything bar for Wayland";
        Documentation = "man:wob(1)";
        PartOf = [ "graphical-session.target" ];
        After = ["graphical-session-pre.target"];
        ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
        # ConditionPathExistsGlob = ["%t/wayland-*"];
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
        # ConditionPathExistsGlob = ["%t/wayland-*"];
      };

      Install.WantedBy = ["sockets.target"];
    };
  };
}
