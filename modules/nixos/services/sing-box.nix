{
  lib,
  pkgs,
  config,
  ...
}:
# Copy: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/sing-box.nix
# And: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/mihomo.nix
let
  cfg = config.services'.sing-box;
in
{
  options = {
    services'.sing-box = {
      enable = lib.mkEnableOption "sing-box universal proxy platform";
      package = lib.mkPackageOption pkgs "sing-box" { };
      configFile = lib.mkOption {
        type = lib.types.path;
        description = "Configuration file to use.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.sing-box = {
      preStart = "[ -e $STATE_DIRECTORY/ui ] && rm -fr $STATE_DIRECTORY/ui; ln -sf ${pkgs.zashboard} $STATE_DIRECTORY/ui";
      serviceConfig = {
        User = "sing-box";
        Group = "sing-box";
        StateDirectory = "sing-box";
        StateDirectoryMode = "0700";
        # RuntimeDirectory = "sing-box";
        # RuntimeDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/sing-box";
        LoadCredential = "config.jsonc:${cfg.configFile}";
        ExecStart = [
          ""
          "${lib.getExe pkgs.sing-box} run -c \${CREDENTIALS_DIRECTORY}/config.jsonc -D \${STATE_DIRECTORY}"
        ];
        Restart = "on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };

    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    users = {
      users.sing-box = {
        isSystemUser = true;
        group = "sing-box";
        home = "/var/lib/sing-box";
      };
      groups.sing-box = { };
    };
  };
}
