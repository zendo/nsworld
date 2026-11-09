{
  flake.modules.nixos.selfhosted =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      systemd.services.comigo = {
        enable = lib.mkDefault false;
        after = [ "network.target" ];
        wants = [ "network.target" ];
        # https://comigo.xyz/manual/deployment#enviroment-variables
        # 注意: comigo 不支持指定监听地址，固定 0.0.0.0
        environment = {
          HOME = "%S/comigo";
          COMIGO_PORT = toString config.myVars.ports.comigo;
          COMIGO_ENABLE_UPLOAD = "true";
        };
        serviceConfig = {
          StateDirectory = "comigo";
          StateDirectoryMode = "0700";
          ExecStart = "${lib.getExe pkgs.comigo} run --no-tui --no-default-library";
          Restart = "on-failure";
          DynamicUser = true;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
}
