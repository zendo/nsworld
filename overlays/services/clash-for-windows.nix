{ config, lib, pkgs, ... }:

{
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

      systemd.services.clash-for-windows = lib.mkIf cfg.tunMode {
        unitConfig = {
          Description = "clash-for-windows service";
          Documentation = "https://github.com/Fndroid/clash_for_windows_pkg/issues/3464";
          After = [
            "network.target"
            "network-online.target"
            "nftables.service"
            "iptables.service"
            # "ip6tables.service"
            # "nss-lookup.target"
          ];
        };

        serviceConfig = {
          # User = "root";
          ExecStart = "${pkgs.clash-for-windows}/opt/clash-for-windows/resources/static/files/linux/x64/service/clash-core-service";
          Restart = "always";
          RestartSec = 5;
          Type = "simple";
        };

        wantedBy = [ "multi-user.target" ];
      };

      meta.maintainers = with lib.maintainers; [ zendo ];
    };
}
