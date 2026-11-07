/*
  wdisplays // set the right outputs
  install -Dm644 /dev/null ~/.config/shikane/config.toml
  shikane &
  shikanectl export $(uname -n)
  fg shikane
*/
{
  flake.modules.nixos.services =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.services'.shikane;
    in
    {
      options.services'.shikane = {
        enable = lib.mkEnableOption "shikane, A dynamic output configuration tool that automatically detects and configures connected outputs based on a set of profiles.";
        package = lib.mkPackageOption pkgs "shikane" { };
        systemd.target = lib.mkOption {
          type = lib.types.str;
          description = ''
            The systemd target that will automatically start the Kanshi service.
          '';
          default = "graphical-session.target";
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ];

        systemd.user.services.shikane = {
          unitConfig = {
            Description = "Dynamic output configuration tool";
            Documentation = "man:shikane(1)";
            ConditionEnvironment = "WAYLAND_DISPLAY";
            PartOf = cfg.systemd.target;
            Requires = cfg.systemd.target;
            After = cfg.systemd.target;
          };
          serviceConfig = {
            Type = "simple";
            ExecStart = "${lib.getExe cfg.package}";
            Restart = "always";
          };
          wantedBy = [ cfg.systemd.target ];
        };
      };
      meta.maintainers = [ lib.maintainers.zendo ];
    };

  flake.modules.hjem.links =
    { pkgs, ... }:
    {
      xdg.config.files."shikane/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
        profile = [
          {
            name = "yoga";
            output = [
              {
                enable = true;
                search = [
                  "m=0x8A90"
                  "s="
                  "v=Lenovo Group Limited"
                ];
                mode = "2880x1800@90Hz";
                position = "0,0";
                scale = 2;
                transform = "normal";
                adaptive_sync = false;
              }
            ];
          }
          {
            name = "svp";
            output = [
              {
                enable = true;
                search = [
                  "m=VVX13F009G00"
                  "s="
                  "v=Panasonic Industry Company"
                ];
                mode = "1920x1080@60Hz";
                position = "0,0";
                scale = 1.2;
                transform = "normal";
                adaptive_sync = false;
              }
            ];
          }
        ];

      };
    };
}
