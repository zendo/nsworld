/*
  后端 = nftables(services.firewalld.enable = false 且 networking.nftables.enable = true
  时,networking.firewall.backend 默认就是 "nftables")。

  为什么不用 firewalld:
    - 所有 nixpkgs 模块的 openFirewall 都往 networking.firewall.* 写,nftables 后端全兑现;
      切成 firewalld 后端后 interfaces.* 会直接断言失败,extraInputRules 是静默丢弃
    - 规则声明式、进 git、nft list ruleset 就是全部真相
    - firewalld 的运行时改动(firewall-cmd)重启就没了,加了 --permanent 又不在 git 里

  ⚠ 这个组是通用的:svp 直接引入,rmt / yoga 通过 modules/nixos-imports.nix 引入。
    所以这里只放"每台机器都要的",具体端口一律交给各服务模块的 openFirewall;
    只属于某台机器的端口写在那台的 host 模块里,例如:
      svp  的 BT 对等端口(6881-6890)→ modules/hosts/svp/configuration.nix
      yoga 的 mihomo 7890 / libvirt virbr0 → modules/hosts/yoga/configuration.nix

  排查用的命令(真出问题的时候按顺序看):
    sudo nft list tables | grep nixos-fw            # 防火墙有没有真的加载
    sudo nft list chain inet nixos-fw input         # policy drop + 命中计数
    sudo nft list chain inet nixos-fw input-allow   # 端口白名单(全部真相都在这)
    nstat -az | grep -i InAddrErrors                # rp_filter 丢包:能发出去但回不来
    dmesg | grep -iE "martian|rp_filter"
    # 怀疑 rp_filter(尤其用了 TUN / 策略路由)时,先临时关掉验证:
    #   networking.firewall.checkReversePath = false;
    # 单个连接为什么被拒,可以临时打开日志:
    #   networking.firewall.logRefusedConnections = true;
    #   journalctl -kf | grep "refused connection"
*/
{
  flake.modules.nixos.firewall =
    { ... }:
    {
      networking.nftables.enable = true;

      networking.firewall = {
        enable = true;

        # 默认就是 "loose",显式写出来:TUN(mihomo)、tailscale 子网路由、libvirt
        # 这类非对称路由场景不会被 rp_filter 误杀。
        checkReversePath = "loose";

        # 被拒连接不写 journal(默认就是 false,写出来免得以后莫名被打开刷屏)
        logRefusedConnections = false;
      };

      # https://github.com/evilsocket/opensnitch
      # services.opensnitch.enable = true;

      # firewalld 保持关闭。
      # ⚠ 一旦 services.firewalld.enable = true,networking.firewall.backend 会自动变成
      #   "firewalld",那时 interfaces.* 直接断言失败、extraInputRules 静默失效。
      #   真要用 firewalld,规则得改写成 services.firewalld.zones。
      services.firewalld.enable = false;
    };
}
