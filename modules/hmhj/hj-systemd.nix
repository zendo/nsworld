{
  flake.modules.hjem.hj-systemd =
    { lib, pkgs, ... }:
    {
      packages = with pkgs; [
        vicinae
      ];

      # vicinae
      # \:p flake.homeConfigurations.iab.config.systemd.user.services.vicinae
      # https://github.com/nix-community/home-manager/blob/master/modules/programs/vicinae/default.nix
      systemd.services.vicinae = {
        unitConfig = {
          Description = "Vicinae server daemon";
          Documentation = [ "https://docs.vicinae.com" ];
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
          X-Restart-Triggers = [ ];
        };
        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.vicinae} server";
          Restart = "always";
          RestartSec = 5;
          KillMode = "process";
        };
        wantedBy = [ "graphical-session.target" ];
      };

    };
}
