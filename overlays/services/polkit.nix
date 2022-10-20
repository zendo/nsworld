{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.polkit;

in {
  meta.maintainers = [ hm.maintainers.zendo ];

  options.services.polkit = {
    enable = mkEnableOption "polkit";
  };

  config = mkIf cfg.enable {

      systemd.user.services.polkit-agent-gnome = {
      Unit = {
        Description = "A dbus session bus service that is used to bring up authentication dialogs";
        Documentation = ["man:polkit(8)"];
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
        # ConditionEnvironment = [ "XDG_CURRENT_DESKTOP=sway" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-abort";
        # RestartSec = 5;
        # Restart = "always";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
