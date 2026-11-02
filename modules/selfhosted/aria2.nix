/*
  curl http://127.0.0.1:4104/jsonrpc \
    -H 'Content-Type: application/json' \
    -d '{"jsonrpc":"2.0","id":"test","method":"aria2.getVersion","params":["token:123"]}'
*/
{
  flake.modules.nixos.selfhosted =
    { config, lib, pkgs, ... }:
    let
      aria2File = pkgs.writeText "aria2File" "123";
    in
    {
      services.aria2 = {
        # openPorts = config.networking.firewall.enable; # RPC 走 loopback,由 Caddy 反代
        rpcSecretFile = aria2File;
        serviceUMask = "0002";
        downloadDirPermission = "0775";
        settings = {
          dir = "/data/temp";
          # Remote Procedure Call
          # http://aria2.home.arpa/jsonrpc
          enable-rpc = true;
          rpc-listen-port = config.myVars.ports.aria2;
          # rpc-listen-all = true; # 默认只监听 127.0.0.1,保持
          # Download
          continue = true; # 断点续传
          max-concurrent-downloads = 5; # 最大同时下载数
          # BitTorrent
          # 对等端口不属于 ports.nix 的方案(见那边的"例外"),给 rqbit 留出 6890
          listen-port = [
            {
              from = 6881;
              to = 6889;
            }
          ];
          dht-listen-port = "6881-6889";
          bt-save-metadata = true; # 保存磁力链接为 .torrent
          enable-dht = true; # 启用 IPv4 DHT
          enable-peer-exchange = true; # 已经连接的 Peer 节点交换
          seed-time = 30; # 最多做种 30 分钟
        };
      };

      # Allow aria2 to access downloadDir.
      # mkIf 必须包在 users.users 这一层:如果只把 extraGroups 的值包成 mkIf,
      # attrsOf 依然会因为路径里有 users.users.aria2 而创建这个用户(然后断言失败)。
      users.users = lib.mkIf config.services.aria2.enable {
        aria2.extraGroups = [ "users" ];
      };

      # BT 的对等连接需要外部主动入站,和反代无关,按需单独放行:
      # networking.firewall.allowedUDPPortRanges = config.services.aria2.settings.listen-port;

    };
}
