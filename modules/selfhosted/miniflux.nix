{
  flake.modules.nixos.selfhosted =
    { config, pkgs, ... }:
    {
      services.miniflux = {
        adminCredentialsFile = pkgs.writeText "minifluxKeyFile" ''
          ADMIN_USERNAME=demo
          ADMIN_PASSWORD=123456
        '';
        config = {
          LISTEN_ADDR = "127.0.0.1:${toString config.myVars.ports.miniflux}";
          # 生成 Feed 里的绝对链接用,必须是外部访问地址
          BASE_URL = "http://miniflux.home.arpa";
        };
      };

      # services.rsshub = {
      #   enable = true;
      #   openFirewall = config.networking.firewall.enable;
      #   settings = {
      #     PORT = 1209;
      #     REQUEST_TIMEOUT = "3000";
      #     REQUEST_RETRY = "10";
      #     CHROMIUM_EXECUTABLE_PATH = lib.getExe pkgs.firefox;
      #   };
      # };

    };
}
