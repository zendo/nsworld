{ config, lib, pkgs, ... }:

{
  options.programs.clash-verge = {
    enable = lib.mkEnableOption (lib.mdDoc ''
      clash-verge.
    '');

    autoStart = lib.mkEnableOption (lib.mdDoc ''
      clash-verge Autostart.

      Note that `Auto Launch` in app will not working, please don't select it.
    '');

    tunMode = lib.mkEnableOption (lib.mdDoc ''
      clash-verge Tun Mode.
    '');

    # example
    # autoStart = lib.mkOption {
    #   default = false;
    #   type = lib.types.bool;
    #   description = lib.mdDoc "Whether rog-control-center should be started automatically.";
    # };
  };

  config =
    let
      cfg = config.programs.clash-verge;
    in
    lib.mkIf cfg.enable {

      environment.systemPackages =  [
        pkgs.clash-verge
        (lib.mkIf cfg.autoStart (pkgs.makeAutostartItem {
          name = "clash-verge";
          package = pkgs.clash-verge;
        }))
      ];

      security.wrappers.clash-verge = lib.mkIf cfg.tunMode {
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service,cap_net_admin=+ep";
        source = "${lib.getExe pkgs.clash-verge}";
      };
    };

  meta.maintainers = with lib.maintainers; [ zendo ];
}
