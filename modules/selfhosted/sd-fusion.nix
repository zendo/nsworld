{
  flake.modules.nixos.selfhosted =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      systemd.services.fusion = {
        enable = lib.mkDefault false;
        after = [ "network.target" ];
        wants = [ "network.target" ];
        # https://github.com/0x2E/fusion/blob/master/.env.example
        # 注意: fusion 不支持指定监听地址,固定 :PORT 监听 0.0.0.0;
        # 外部进不来是因为防火墙没开 4204,访问只走 Caddy
        environment = {
          FUSION_PORT = toString config.myVars.ports.fusion;
          FUSION_DB_PATH = "/var/lib/fusion/fusion.db";
          # 登录密码;想让浏览器/客户端登录,就不要开 ALLOW_EMPTY_PASSWORD。
          # 想不进 nix store 就改成 environmentFile = /run/secrets/fusion.env
          FUSION_PASSWORD = "123";
          # 反代在本机,让登录限流 / 日志看到真实客户端 IP 而不是 127.0.0.1
          FUSION_TRUSTED_PROXIES = "127.0.0.1";
        };
        serviceConfig = {
          StateDirectory = "fusion";
          StateDirectoryMode = "0700";
          ExecStart = "${lib.getExe pkgs.fusion}";
          Restart = "on-failure";
          DynamicUser = true;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
}
