/*
  这里的分工:

    .local        mDNS / Avahi       只在家里的二层网段里"发现邻居",不出网段
    home.arpa     单播 DNS(路由器)   *.home.arpa -> 192.168.2.30,给所有设备用
    其它          上游 DNS + resolved 缓存

  两条必须守住:
    1. systemd-resolved 只管单播 DNS 和缓存,【不要】自己开 mDNS,
       否则它会去 bind 5353/udp 和 avahi 抢端口,表现是 .local 时好时坏;
    2. avahi 只管 .local 和 5353/udp,nsswitch 里由 nssmdns4 插在
       resolve 之前的 mdns4_minimal [NOTFOUND=return],查到/查不到都不会再落回 DNS。

  为什么 *.home.arpa 不走 mDNS:
    RFC 6762 规定 mDNS 用 .local;而且 mDNS 的 SRV 记录只能指向一个真实主机名,
    没法在一台机器上同时宣告 navidrome/goshs/memos/... 十几个域名。
    多域名只能靠单播 DNS 的通配(路由器),这也是 modules/selfhosted/caddy.nix 的前提。

  常用检查:
    resolvectl status                    # 每个 link 的 DNS / 搜索域
    resolvectl query navidrome.home.arpa
    doggo navidrome.home.arpa
    ping svp.local                       # mDNS 正反查
    avahi-browse -rt _workstation._tcp   # 看同网段有哪些 mDNS 主机
    ss -lunp | grep 5353                 # 只应该有 avahi,不能有 systemd-resolve
    journalctl -u avahi-daemon -u systemd-resolved -b
*/
{
  flake.modules.nixos.dns = {
    services.resolved = {
      enable = true;
      settings.Resolve = {
        # 一旦这里为 true,resolved 自己会去 bind 5353/udp 做 mDNS,
        # 和 avahi 抢端口,.local 解析会随机失败
        MulticastDNS = false;

        # LLMNR 是 Windows 的本地广播解析;本地解析已由 mDNS + 单播 DNS 覆盖,
        # 关掉少一层广播噪音(也少一个 5355/udp 的来源)
        LLMNR = false;

        # 上游支持 DNSSEC 就用,不支持就自动降级 —— 不会因为路由器不支持就挂掉
        DNSSEC = "allow-downgrade";

        # 上游(路由器)不支持 DoT。开了会让所有解析失败;
        # 等换成本地 unbound / 公共 DoT 再打开
        DNSOverTLS = false;

        FallbackDNS = [
          "223.5.5.5" # AliDNS
          "119.29.29.29" # DNSPod
        ];
      };
    };

    # 宣告 svp.local,并解析别人的 *.local
    services.avahi = {
      # nsswitch: 插入 mdns4_minimal [NOTFOUND=return]
      nssmdns4 = true;
      # 家庭网段是纯 IPv4。开 IPv6 mDNS 只会让每次解析先等一次 AAAA 超时
      nssmdns6 = false;
      # 5353/udp (防火墙开启时才生效)
      openFirewall = true;

      settings.server = {
        # host-name 默认取 networking.hostName,即宣告 svp.local
        domain-name = "local"; # mDNS 就该用 .local,别改成 home.arpa
        use-ipv4 = true;
        use-ipv6 = false;
        # 把 mDNS 挡在 tailnet 和容器网桥之外:
        # 远程访问走 tailnet 的 split DNS(单播),容器里也没有 avahi 客户端。
        # 用 deny 而不是 allow:网卡改名/插网线都不会把 DNS 弄断。
        deny-interfaces = [
          "tailscale0"
          "docker0"
          "podman0"
          "cni-podman0"
          "virbr0"
        ];
      };

      settings.publish = {
        # ⚠ nixpkgs 这个模块的默认值和 avahi 上游相反:
        #   disable-publishing 默认 true —— 即默认【不宣告自己】,
        #   只解析别人。不改成 false 的话,别的机器 ping svp.local 是不通的。
        disable-publishing = false;
        # 服务器上没人跑桌面程序,不需要给 user service 留发布通道
        disable-user-service-publishing = true;
        # 宣告所有本地地址(192.168.2.30),这样 svp.local 能正查到 A 记录
        publish-addresses = true;
        # 让 Finder / 资源管理器 的"网络"里能看到这台机器
        publish-workstation = true;
        # 宣告本地域名,方便别人浏览
        publish-domain = true;
        # HINFO 会广播 CPU 型号和操作系统,纯属多余的信息泄露
        publish-hinfo = false;
      };
      # 两个都别开:
      #   reflector     把 mDNS 转发到别的网段(等于跨网桥接广播)
      #   wideArea      中心化 DNS-SD,牵涉 CVE-2024-52615
      settings.reflector.enable-reflector = false;
    };

    # ⚠ 联动提醒 tailscale.nix 里有一个 dnsmasq(给 tailnet 做
    #   home.arpa 的 split DNS)。必须保持 services.dnsmasq.resolveLocalQueries = false,
    #   因为它默认 true 会把 networking.nameservers 改成 127.0.0.1,
    #   而 resolved 的 DNS 默认就是取 networking.nameservers —— 会自己咬自己。
  };
}
