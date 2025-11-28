{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  cfg = config.services'.sing-box;
in
{
  options = {
    services'.sing-box = {
      enable = lib.mkEnableOption "sing-box universal proxy platform";
      package = lib.mkPackageOption pkgs "sing-box" { };
    };
  };
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/sing-box.nix
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
        ExecStart = [
          ""
          "${lib.getExe pkgs.sing-box} run -c /home/${username}/code/subs/config.jsonc -D \${STATE_DIRECTORY}"
        ];
        Restart = "on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };

    # for polkit rules
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
