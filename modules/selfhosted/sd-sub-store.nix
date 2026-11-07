{
  flake.modules.nixos.selfhosted =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # REF: https://surge.tel/08/2930 & https://hub.docker.com/r/xream/sub-store
      systemd.services.sub-store = {
        enable = lib.mkDefault false;
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        environment = {
          # Node 24 的 happy-eyeballs(autoSelectFamily) 每条地址只等 250ms。svp 只有 ULA IPv6、
          # 没有 IPv6 默认路由，DNS 又同时返回 A/AAAA，到 Cloudflare 的 IPv4 握手经常 >250ms，
          # 结果全部地址被判 ETIMEDOUT。禁用自动选路并优先 IPv4，避免去试不可用的 IPv6。
          NODE_OPTIONS = "--dns-result-order=ipv4first --no-network-family-autoselection";
          SUB_STORE_DATA_BASE_PATH = "%S/sub-store";
          SUB_STORE_FRONTEND_PATH = "${pkgs.sub-store-frontend}";
          SUB_STORE_BACKEND_API_HOST = "127.0.0.1";
          SUB_STORE_BACKEND_API_PORT = toString config.myVars.ports.sub-store;
          SUB_STORE_BACKEND_MERGE = "true";
          # openssl rand -base64 12
          SUB_STORE_FRONTEND_BACKEND_PATH = "/kewejyo3baNXPELk";
          SUB_STORE_CORS_ALLOWED_ORIGINS = "*";
          # SUB_STORE_BACKEND_SYNC_CRON = "55 23 * * *"; # 23:55
        };
        serviceConfig = {
          StateDirectory = "sub-store";
          StateDirectoryMode = "0700";
          ExecStart = "${lib.getExe pkgs.sub-store}";
          Restart = "on-failure";
          DynamicUser = true;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
}
