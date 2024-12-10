{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.clash-client;
in
{
  options.programs.clash-client = {
    enable = lib.mkEnableOption "Clash Client";
    package = lib.mkPackageOption pkgs "mihomo-party" { };
    autoStart = lib.mkEnableOption "Clash Client auto launch";
    tunMode = lib.mkEnableOption "Clash Client TUN mode";
  };

  config = lib.mkIf cfg.enable {
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
  };

  meta.maintainers = with lib.maintainers; [ zendo ];
}
