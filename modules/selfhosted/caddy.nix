/*
  统一入口:所有服务只监听 127.0.0.1,只有 Caddy 的 :80 对外。
  端口一律从 config.myVars.ports 取,规则见 ports.nix。

  *.home.arpa 的解析(RFC 8375 保留域名,不会撞公网)全部交给路由器 / 本地 DNS,
  NixOS 这边不写 /etc/hosts,保证只有一处事实来源:
      *.home.arpa  ->  192.168.2.30

  因为后端只绑 loopback,各服务模块里的 openFirewall 全部注释掉了:
  反代走 127.0.0.1,NixOS 防火墙对 loopback 无条件放行,不需要开端口。
*/
{
  flake.modules.nixos.host-svp =
    { config, pkgs, ... }:
    let
      p = config.myVars.ports;
    in
    {
      # 启用在 host 侧: services.caddy.enable = true;
      services.caddy = {
        # 唯一需要放行的东西(防火墙开启时才有意义);nixpkgs 默认是 false
        openFirewall = true;

        virtualHosts = {
          # 兜底: 裸 IP 或任何没匹配上的 Host 都送去导航页。
          # :80 = 匹配所有 Host;具体域名优先级更高,不影响下面那些站。
          # 用 302 而不是 301,免得浏览器永久缓存(以后想看板换了也不用清缓存)
          ":80".extraConfig = ''
            redir * http://dynacat.home.arpa{uri} 302
          '';

          "http://navidrome.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.navidrome}
          '';

          "http://goshs.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.goshs}
          '';

          # goshs 的 WebDAV
          "http://webdav.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.webdav}
          '';

          # demo / 123456
          "http://miniflux.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.miniflux}
          '';

          "http://memos.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.memos}
          '';

          # http://aria2.home.arpa:80/jsonrpc 123
          "http://aria2.home.arpa".extraConfig = ''
            handle /jsonrpc {
              reverse_proxy 127.0.0.1:${toString p.aria2}
            }
            handle {
              root * ${pkgs.ariang}/share/ariang
              encode zstd gzip
              file_server
            }
          '';

          "http://rqbit.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.rqbit}
          '';

          "http://sub-store.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.sub-store}
          '';

          "http://comigo.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.comigo}
          '';

          "http://fusion.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.fusion}
          '';

          "http://karakeep.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.karakeep}
          '';

          "http://dynacat.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.dynacat}
          '';

          "http://scrutiny.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.scrutiny}
          '';

          "http://beszel.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.beszel}
          '';

          # websocket(/notifications/hub)由 reverse_proxy 自动处理 Upgrade
          "http://vaultwarden.home.arpa".extraConfig = ''
              reverse_proxy 127.0.0.1:${toString p.vaultwarden}
            # '';

          "http://suwayomi.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.suwayomi}
          '';

          "http://dufs.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.dufs}
          '';

          # 同步协议(22000/21027)不走反代,由 services.syncthing.openDefaultPorts 放行
          "http://syncthing.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.syncthing}
          '';

          "http://kavita.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.kavita}
          '';

          # 需要 websocket(App 同步/上传进度)和大 body,reverse_proxy 默认都放行
          "http://immich.home.arpa".extraConfig = ''
              reverse_proxy 127.0.0.1:${toString p.immich}
            # '';

          "http://homepage.home.arpa".extraConfig = ''
            reverse_proxy 127.0.0.1:${toString p.homepage}
          '';

          # 备用: reactflux 前端
          # "http://reactflux.home.arpa".extraConfig = ''
          #   root * ${pkgs.reactflux}
          #   try_files {path} {path}/ /index.html
          #   file_server
          # '';
        };
      };
    };
}
