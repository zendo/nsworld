{
  flake.modules.nixos.selfhosted =
    { config, lib, ... }:
    {
      services.rqbit = {
        # openFirewall = config.networking.firewall.enable; # HTTP 走 loopback,由 Caddy 反代
        httpHost = "127.0.0.1";
        httpPort = config.myVars.ports.rqbit;
        # BT 对等端口,不属于 ports.nix 的方案(见那边的"例外")
        peerPort = 6890;
        downloadDir = lib.mkDefault "/data/temp";
      };

      # Allow rqbit to access downloadDir.
      # mkIf 必须包在 users.users / systemd.services 这一层:如果只把叶子值包成 mkIf,
      # attrsOf 依然会因为路径里有这段东西而创建用户/生成空 unit(然后断言失败)。
      users.users = lib.mkIf config.services.rqbit.enable {
        rqbit.extraGroups = [ "users" ];
      };
      # Allow group members to modify downloaded files.
      systemd.services = lib.mkIf config.services.rqbit.enable {
        rqbit.serviceConfig.UMask = lib.mkForce "0002";
      };

      # BT 的对等连接需要外部主动入站(TCP + uTP),和反代无关,按需单独放行:
      # networking.firewall.allowedTCPPorts = [ config.services.rqbit.peerPort ];
      # networking.firewall.allowedUDPPorts = [ config.services.rqbit.peerPort ];
    };
}
