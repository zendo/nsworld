{
  flake.modules.nixos.selfhosted =
    { config, lib, ... }:
    {
      config = lib.mkIf config.services.karakeep.enable {
        services.karakeep = {
          # 模块没有 host/port 选项,进程固定监听 0.0.0.0;
          # 外部进不来是因为防火墙没开这个端口,访问只走 Caddy。
          # meilisearch(全文搜索)和 karakeep-init 的密钥都由模块自动带起来。
          extraEnvironment = {
            PORT = toString config.myVars.ports.karakeep;
            # NextAuth 用,必须和实际访问地址一致,否则登录会跳到错域名
            NEXTAUTH_URL = "http://karakeep.home.arpa";
            DISABLE_NEW_RELEASE_CHECK = "true";
            # 第一个账号注册完可以打开,免得局域网里谁都能自助注册
            # DISABLE_SIGNUPS = "true";
          };

          # 截图 / 网页存档靠 headless chromium(默认开,常驻几百 MB);
          # 只要书签 + 全文搜索的话可以关掉
          browser.enable = false;
        };
      };
    };
}
