{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      services.memos = {
        openFirewall = config.networking.firewall.enable;
        dataDir = "/data/backups/memos/";
        settings = {
          MEMOS_MODE = "prod";
          MEMOS_ADDR = "0.0.0.0";
          MEMOS_PORT = "5230";
          MEMOS_DATA = config.services.memos.dataDir;
          MEMOS_DRIVER = "sqlite";
          MEMOS_INSTANCE_URL = "http://localhost:5230";
        };
      };
    };
}
