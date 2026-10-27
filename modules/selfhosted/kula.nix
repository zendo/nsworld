{
  flake.modules.nixos.selfhosted =
    { lib, pkgs, ... }:
    {
      systemd.services.kula = {
        enable = lib.mkDefault false;
        after = [ "network.target" ];
        wants = [ "network.target" ];
        # https://github.com/c0m4r/kula/blob/main/docs/user/14-cli-reference.md#environment-variables
        environment = {
          KULA_DIRECTORY = "%S/kula";
          KULA_LISTEN = "0.0.0.0";
          KULA_PORT = "27969";
        };
        serviceConfig = {
          StateDirectory = "kula";
          StateDirectoryMode = "0700";
          ExecStart = "${lib.getExe pkgs.kula} serve";
          Restart = "on-failure";
          DynamicUser = true;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
}
