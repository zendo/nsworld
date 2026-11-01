{
  flake.modules.nixos.host-yoga =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        mihomo
        sing-box
        zashboard
        # gui-for-singbox
        # gui-for-clash
      ];

      services.sing-box = {
        # enable = true;
        settings = {
          _secret = "/home/${config.myVars.user}/Projects/subs/config.jsonc";
          quote = false;
        };
      };

      services.mihomo = {
        enable = true;
        tunMode = true;
        webui = pkgs.zashboard;
        configFile = "/home/${config.myVars.user}/Projects/subs/config.yaml";
      };

      # 仅在启用 mihomo 时接管系统 DNS，否则用默认（DHCP）DNS。
      # 原因：systemd-resolved 会把 link DNS（路由器 192.168.2.1）的查询绑定到物理网卡，
      # 绕过 tun，明文出网被污染（wikipedia/reddit 解析出 Facebook/Twitter IP）。
      # 指向 mihomo tun 内部 DNS + `~.` 覆盖所有 link DNS，查询就会进入 tun，
      # 由 mihomo 的 fake-ip / 分流策略统一处理。
      # resolvectl status / resolvectl query google.com
      services.resolved.settings.Resolve = lib.mkIf config.services.mihomo.enable {
        # DNS 地址 = tun地址(fake-ip-range 首地址) + 1
        # sudo nft list table inet mihomo | grep dnat
        DNS = [ "198.18.0.2" ];
        Domains = [ "~." ];
      };

      # services.daeWithConfig.enable = true;
      # or
      services.dae = {
        # enable = true;
        configFile = "/home/${config.myVars.user}/Projects/subs/dae-config.dae";
      };
    };
}
