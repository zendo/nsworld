{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      services.memos = {
        # dataDir = "/var/lib/memos/";
        settings = {
          MEMOS_MODE = "prod";
          MEMOS_ADDR = "127.0.0.1";
          MEMOS_PORT = toString config.myVars.ports.memos;
          MEMOS_DATA = config.services.memos.dataDir;
          MEMOS_DRIVER = "sqlite";
          # 分享链接 / Webhook 里用的对外地址
          MEMOS_INSTANCE_URL = "http://memos.home.arpa";
        };
      };
    };
}
