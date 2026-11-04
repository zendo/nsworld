{
  # https://github.com/AndreGeng/FelixDict
  flake.modules.nixos.services =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.services'.vicinae;
    in
    {
      options.services'.vicinae = {
        enable = lib.mkEnableOption "vicinae launcher daemon";
        package = lib.mkPackageOption pkgs "vicinae" { };
        systemd.target = lib.mkOption {
          type = lib.types.str;
          description = ''
            The systemd target that will automatically start the vicinae daemon.
          '';
          default = "graphical-session.target";
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];

        systemd.user.services.vicinae = {
          unitConfig = {
            Description = "Vicinae server daemon";
            Documentation = [ "https://docs.vicinae.com" ];
            ConditionEnvironment = "WAYLAND_DISPLAY";
            PartOf = cfg.systemd.target;
            Requires = cfg.systemd.target;
            After = cfg.systemd.target;
          };
          serviceConfig = {
            Type = "simple";
            ExecStart = "${lib.getExe cfg.package} server";
            Restart = "always";
            RestartSec = 5;
            KillMode = "process";
          };
          wantedBy = [ cfg.systemd.target ];
        };
      };
    };

  # flake.modules.homeManager.vicinae = {
  #   programs.vicinae = {
  #     enable = true;
  #     systemd.enable = true;
  #     # vicinae config default | wl-copy
  #     # settings = {
  #     # };
  #   };
  # };
}
