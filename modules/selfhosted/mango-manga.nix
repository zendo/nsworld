{
  flake.modules.nixos.selfhosted =
    { lib, pkgs, ... }:
    {
      systemd.services.mango-manga = {
        enable = lib.mkDefault false;
        after = [ "network.target" ];
        wants = [ "network.target" ];
        # https://github.com/apixelsnet/mango#settings
        environment = {
          MANGO_DATA = "/data/db/mango-manga";
          MANGO_LISTEN = "0.0.0.0:8789";
          MANGO_PASSWORD = "12345678";
        };
        serviceConfig = {
          StateDirectory = "mango-manga";
          StateDirectoryMode = "0700";
          ExecStart = "${lib.getExe pkgs.mango-manga}";
          Restart = "on-failure";
          # DynamicUser = true;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
}
