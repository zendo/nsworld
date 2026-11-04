{
  flake.modules.nixos.services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services'.veila;
    in
    {
      options.services'.veila = {
        enable = lib.mkEnableOption "Veila screen locker";

        package = lib.mkPackageOption pkgs "veila" { };

        service.enable = lib.mkEnableOption "the Veila daemon (`veila daemon`) as a systemd user service";
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];
        security.pam.services.veila = { };

        systemd.user.services.veila = {
          description = "Veila screen locker daemon";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${cfg.package}/bin/veilad";
            Restart = "on-failure";
            RestartSec = 2;
            KillMode = "process";
            SendSIGKILL = false;
            TimeoutStopSec = "infinity";
            LimitCORE = 0;
            PassEnvironment = "WAYLAND_DISPLAY XDG_SESSION_ID XDG_SESSION_TYPE XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE SWAYSOCK NIRI_SOCKET";
          };
        };
      };
    };
}
