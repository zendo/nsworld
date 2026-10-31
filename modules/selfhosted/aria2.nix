/*
  curl http://127.0.0.1:6800/jsonrpc \
    -H 'Content-Type: application/json' \
    -d '{"jsonrpc":"2.0","id":"test","method":"aria2.getVersion","params":["token:123"]}'
*/
{
  flake.modules.nixos.selfhosted =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      aria2File = pkgs.writeText "aria2File" "123";
    in
    lib.mkIf (config.services.aria2.enable) {
      services.aria2 = {
        openPorts = config.networking.firewall.enable;
        rpcSecretFile = aria2File;
        serviceUMask = "0002";
        downloadDirPermission = "0775";
        settings = {
          dir = "/data/temp";
          # Remote Procedure Call
          # http://localhost:6800/jsonrpc
          enable-rpc = true;
          # rpc-listen-all = true; # 允许所有网络接口访问 RPC
          # rpc-listen-port = 6800; # 默认 6800
          # Download
          continue = true; # 断点续传
          max-concurrent-downloads = 5; # 最大同时下载数
          # BitTorrent
          bt-save-metadata = true; # 保存磁力链接为 .torrent
          enable-dht = true; # 启用 IPv4 DHT
          enable-peer-exchange = true; # 已经连接的 Peer 节点交换
          seed-time = 30; # 最多做种 30 分钟
        };
      };

      # Allow aria2 to access downloadDir.
      users.users.aria2.extraGroups = [ "users" ];

      services.caddy = {
        enable = true;

        # http://192.168.2.30:6819
        virtualHosts.":6819".extraConfig = ''
          handle /jsonrpc {
            reverse_proxy 127.0.0.1:6800
          }

          handle {
            root * ${pkgs.ariang}/share/ariang
            encode zstd gzip
            file_server
          }
        '';
      };

    };
}
