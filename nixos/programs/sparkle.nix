{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.programs.sparkle = {
    enable = lib.mkEnableOption "sparkle";
    package = lib.mkPackageOption pkgs "sparkle" { };
    tunMode = lib.mkEnableOption "Setcap for TUN Mode";
    autoStart = lib.mkEnableOption "sparkle auto launch";
  };

  config =
    let
      cfg = config.programs.sparkle;
    in
    lib.mkIf cfg.enable {

      environment.systemPackages = [
        cfg.package
        (lib.mkIf cfg.autoStart (
          pkgs.makeAutostartItem {
            name = "sparkle";
            package = cfg.package;
          }
        ))
      ];

      security.wrappers.sparkle = lib.mkIf cfg.tunMode {
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service,cap_net_raw,cap_net_admin=+ep";
        source = "${lib.getExe cfg.package}";
      };
    };

  meta.maintainers = with lib.maintainers; [ zendo ];
}
