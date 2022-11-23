{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.v2raya;
in
{
  options = {
    services.v2raya = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable the v2rayA service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.v2raya ];

    systemd.services.v2raya = {
      unitConfig = {
        Description = "v2rayA service";
        Documentation = "https://github.com/v2rayA/v2rayA/wiki";
        After = ["network.target" "nss-lookup.target" "iptables.service" "ip6tables.service"];
        Wants = ["network.target"];
      };

      serviceConfig = {
        User = "root";
        ExecStart = "${getExe pkgs.v2raya} --log-disable-timestamp";
        LimitNPROC = 500;
        LimitNOFILE = 1000000;
        Restart = "on-failure";
        Type = "simple";
        Environment = ["V2RAYA_LOG_FILE=/var/log/v2raya/v2raya.log"];
      };

      wantedBy = ["multi-user.target"];

      # required by v2rayA TProxy functionality
      path = with pkgs; [iptables bash iproute2];
    };
  };
}
