{
  flake.modules.nixos.selfhosted =
    { config, lib, ... }:
    {
      # 模块里不启用;host 侧一行:
      #   services.vaultwarden.enable = true;
      config = lib.mkIf config.services.vaultwarden.enable {
        services.vaultwarden = {
          # sqlite 单文件,数据在 /var/lib/vaultwarden
          dbBackend = "sqlite";

          # 每天 23:00 把 db.sqlite3 + attachments/rsa_key 等拷到 /data 的持久子卷;
          # 目录由模块的 tmpfiles 自动建
          backupDir = lib.mkDefault "/data/backups/vaultwarden";

          config = {
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = config.myVars.ports.vaultwarden;

            # 客户端填的服务器地址 / 邀请链接里的地址,必须是外部访问地址
            DOMAIN = "http://vaultwarden.home.arpa";

            # 注册开着谁都能建号(家用一般够用);注册完想收紧就改成 false
            # SIGNUPS_ALLOWED = false;

            # 只记 warn 以上,别把 access log 刷满 journal
            ROCKET_LOG = "critical";
          };
        };
      };
    };
}
