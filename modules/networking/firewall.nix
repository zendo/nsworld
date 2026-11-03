/*
    排查用的命令(出问题的时候按顺序看):
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
  flake.modules.nixos.firewall = {

    networking.nftables.enable = true;

    networking.firewall = {
      enable = true;
      # backend = "nftables"; # 默认后端
      # 默认就是 "loose",显式写出来:TUN(mihomo)、tailscale 子网路由、libvirt
      # 这类非对称路由场景不会被 rp_filter 误杀。
      checkReversePath = "loose";
      # 被拒连接不写 journal(默认就是 false,写出来免得以后莫名被打开刷屏)
      logRefusedConnections = false;
    };

  };
}
