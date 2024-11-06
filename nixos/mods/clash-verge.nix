{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.programs.clash-verge = {
    enable = lib.mkEnableOption "Clash Verge";
    package = lib.mkOption {
      type = lib.types.package;
      description = ''
        The clash-verge package to use. Available options are
        `clash-verge-rev`, `clash-nyanpasu` and `mihomo-party`.
      '';
      example = "pkgs.clash-verge-rev";
    };
    autoStart = lib.mkEnableOption "Clash Verge auto launch";
    tunMode = lib.mkEnableOption "Clash Verge TUN mode";
    serviceMode = lib.mkEnableOption "Clash Verge Service mode";
  };

  config =
    let
      cfg = config.programs.clash-verge;
    in
    lib.mkIf cfg.enable {

      environment.systemPackages = [
        cfg.package
        (lib.mkIf cfg.autoStart (
          pkgs.makeAutostartItem {
            name = lib.getName cfg.package;
            package = cfg.package;
          }
        ))
      ];

      security.wrappers.${lib.getName cfg.package} = lib.mkIf cfg.tunMode {
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service,cap_net_admin=+ep";
        source = "${lib.getExe cfg.package}";
      };

      systemd.services.${lib.getName cfg.package} = lib.mkIf cfg.serviceMode {
        owner = "root";
        enable = true;
        group = "root";
        Restart = "on-failure";
        capabilities = "cap_net_bind_service,cap_net_admin=+ep";
        description = "Clash Verge Service Mode";
        source = "${lib.getExe cfg.package}";
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/clash-verge-service";
        };
        wantedBy = [ "multi-user.target" ];
      };

    };

  meta.maintainers = with lib.maintainers; [ zendo ];
}
