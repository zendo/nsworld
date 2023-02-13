{ config, lib, pkgs, ... }:

{
  # WIP!!!
  options.programs.clash-for-windows = {
    enable = lib.mkEnableOption (lib.mdDoc ''
      clash-for-windows.
    '');

    autoStart = lib.mkEnableOption (lib.mdDoc ''
      clash-for-windows Autostart.

      Note that `Auto Launch` in app will not working, please don't select it.
    '');

    tunMode = lib.mkEnableOption (lib.mdDoc ''
      clash-for-windows Tun Mode.
    '');
  };

  config =
    let
      cfg = config.programs.clash-for-windows;
    in
    lib.mkIf cfg.enable {

      environment.systemPackages = [
        pkgs.clash-for-windows
        (lib.mkIf cfg.autoStart (pkgs.makeAutostartItem {
          name = "clash-for-windows";
          package = pkgs.clash-for-windows;
        }))
      ];

      security.wrappers.clash-for-windows = lib.mkIf cfg.tunMode {
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service,cap_net_admin=+ep";
        source = "${lib.getExe pkgs.clash-for-windows}";
      };

      # https://github.com/Fndroid/clash_for_windows_pkg/issues/3464
      systemd.services.clash-for-windows = lib.mkIf cfg.tunMode {
        unitConfig = {
          Description = "clash-for-windows service";
          Documentation = "https://github.com/v2rayA/v2rayA/wiki";
          After = [
            "network.target"
            # "nss-lookup.target"
            "network-online.target "
            "nftables.service"
            "iptables.service"
            # "ip6tables.service"
          ];
          # Wants = [ "network.target" ];
          Wants = [ "network.target" ];
        };

        serviceConfig = {
          # User = "root";
          ExecStart = "${pkgs.clash-for-windows}/opt/clash-for-windows/resources/static/files/linux/x64/service/clash-core-service";
          # Environment = [ "V2RAYA_LOG_FILE=/var/log/v2raya/v2raya.log" ];
          # LimitNPROC = 500;
          # LimitNOFILE = 1000000;
          Restart = "always";
          RestartSec = 5;
          Type = "simple";
        };
      };

      meta.maintainers = with lib.maintainers; [ zendo ];
    };
}
