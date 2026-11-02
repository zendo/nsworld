/*
  远程访问:全部走 Tailscale(WireGuard),不开公网端口、不做端口转发,
  也不用管运营商封 80/443。

  和现在的关系:一行 Caddy 配置都不用改。后端仍然只监听 127.0.0.1,
  外面进来的流量只是换了个入口(tailscale0 而不是 eth0/wlan0)。

  ┌ 手机 / 笔电(装 Tailscale,登录同一账号)
  └─ WireGuard ─→ svp (100.x.y.z,MagicDNS: svp.<tailnet>.ts.net)
                    ├─ :53   dnsmasq  只回答 *.home.arpa  (split DNS)
                    └─ :80   Caddy    按 Host 反代到 127.0.0.1

  访问方式和在家一模一样: http://navidrome.home.arpa

  ⚠ 上线前建议把 networking.firewall.enable 打开(modules/networking/firewall.nix)。
    现在它是 false,而 comigo 只能绑 0.0.0.0,不挡的话 tailnet 里的设备可以
    绕过 Caddy 直接打 192.168.2.30:4004,顺带 22/445 也是敞开的。
    开了防火墙之后:80/443 由 services.caddy.openFirewall 放行,53 由下面单独放行。

  只能在 admin console 里点的三件事(代码管不到):
    1. Machines -> svp -> Disable key expiry
       (否则密钥 180 天后过期,你会在回家路上发现连不上)
    2. Machines -> svp -> Edit route settings -> 批准 192.168.2.30/32
    3. DNS -> Nameservers -> Add nameserver -> Custom -> 192.168.2.30
       勾上 "Restrict to domain" 填 home.arpa(split DNS)
       这样只有 *.home.arpa 的查询会发给 svp,其它照常走公共 DNS

  首次上线(svp 上):
    sudo tailscale up          # 打印一个 URL,浏览器授权一次
    tailscale status           # 确认在线
*/
{
  flake.modules.nixos.tailscale =
    { config, lib, ... }:
    {
      services.tailscale = {
        enable = true;
        # "server" 才允许 advertise-routes,会顺带打开 ip_forward
        useRoutingFeatures = "server";
        extraUpFlags = [
          # 只把 svp 自己暴露给 tailnet,不整段开放 192.168.2.0/24
          "--advertise-routes=192.168.2.30/32"
        ];
      };

      # 给 tailnet 做 split DNS: *.home.arpa -> 192.168.2.30
      services.dnsmasq = {
        enable = true;
        # 不要接管本机自己的 DNS:systemd-resolved 继续用路由器(split DNS 只给客户端用)
        resolveLocalQueries = false;
        settings = {
          # bind-interfaces + listen-address:只绑 192.168.2.30:53,
          # 不和 systemd-resolved 的 127.0.0.53:53 抢
          bind-interfaces = true;
          listen-address = [ "192.168.2.30" ];
          # 通配:任何 *.home.arpa 都回这台机器
          address = "/home.arpa/192.168.2.30";
          # 只干这一件事,不做递归、不缓存
          no-resolv = true;
          cache-size = 0;
        };
      };

      # 防火墙开着时才有意义:只对 tailnet 开 53,LAN 里没人需要问它
      networking.firewall.interfaces."tailscale0" = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };
    };
}

/*
  可选:想要 HTTPS(tailnet 内部自签)
  ---------------------------------------------------------------------------
  WireGuard 已经把链路加密了,HTTP 并不比 HTTPS 更"裸",所以这一步纯粹是
  为了喂饱某些挑剔的客户端(主要是个别 iOS App 的 ATS 会拒绝 home.arpa 的明文)。

  1) modules/selfhosted/caddy.nix 里把每条 "http://x.home.arpa"
     改成 "https://x.home.arpa",并在 extraConfig 开头加一行:

         "https://navidrome.home.arpa".extraConfig = ''
           tls internal
           reverse_proxy 127.0.0.1:${toString p.navidrome}
         '';

     (15 条都要改,可以先把 virtualHosts 改成 map 生成,就不用手改)

  2) svp 上让 Caddy 自己生成内部 CA:  sudo caddy trust

  3) 每个客户端装一次根证书:
       scp root@svp:/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt .
       iOS:     设置 -> 通用 -> VPN与设备管理(装描述文件)
                设置 -> 通用 -> 关于本机 -> 证书信任设置 -> 打开对该证书的完全信任
       Android: 设置 -> 安全 -> 加密与凭据 -> 安装证书 -> CA 证书
       Linux:   sudo cp root.crt /etc/ssl/certs/ && sudo update-ca-certificates

  4) home.arpa 不可能拿到公共证书(RFC 8375 保留,CA 不签),所以只有两条路:
     - 自签(上面这套,每台设备手动装一次根证书)
     - 换成真域名 + DNS-01 泛域名证书(需要一个域名 + Caddy 的 cloudflare 插件,
       泛域名 A 记录指向 100.64/10 的 tailnet 地址即可,公网其实访问不到)
*/
