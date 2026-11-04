{
  flake.modules.nixos.services =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services'.sweetidle;
    in
    {
      options.services'.sweetidle = {
        enable = lib.mkEnableOption "sweetidle idle daemon";

        package = lib.mkPackageOption pkgs "sweetidle" { };

        service.enable = lib.mkEnableOption "the sweetidle daemon as a systemd user service";
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];
        systemd.packages = [ cfg.package ];

        systemd.user.services.sweetidle = {
          description = "Sweets idle management daemon";
          documentation = [ "https://github.com/naurissteins/sweetidle" ];
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          # hooks run through `sh -c` and need the user's PATH, not the minimal
          # NixOS unit default (which has neither `sh` nor /run/current-system/sw/bin)
          enableDefaultPath = false;
          unitConfig = {
            ConditionEnvironment = "WAYLAND_DISPLAY";
            StartLimitIntervalSec = "60s";
            StartLimitBurst = 10;
          };
          serviceConfig = {
            Type = "exec";
            ExecStart = lib.getExe cfg.package;
            ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
            KillMode = "process";
            Restart = "on-failure";
            RestartSec = "2s";
            TimeoutStopSec = "5s";
          };
          wantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
