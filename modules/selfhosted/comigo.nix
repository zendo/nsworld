{
  flake.modules.nixos.selfhosted =
    { lib, pkgs, ... }:
    {
      systemd.services.comigo = {
        enable = lib.mkDefault false;
        after = [ "network.target" ];
        wants = [ "network.target" ];
        # https://comigo.xyz/manual/deployment#enviroment-variables
        environment = {
          HOME = "%S/comigo";
          COMIGO_PORT = "1239";
          COMIGO_ENABLE_UPLOAD = "true";
        };
        serviceConfig = {
          StateDirectory = "comigo";
          StateDirectoryMode = "0700";
          ExecStart = "${lib.getExe pkgs.comigo} start --no-tui /data/media/manga";
          Restart = "on-failure";
          DynamicUser = true;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
}
