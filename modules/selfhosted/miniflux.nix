{
  flake.modules.nixos.selfhosted =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      keyFile = pkgs.writeText "minifluxKeyFile" ''
        ADMIN_USERNAME=demo
        ADMIN_PASSWORD=123456
      '';
    in
    {
      services.miniflux = {
        adminCredentialsFile = keyFile;
        config = {
          LISTEN_ADDR = "0.0.0.0:8081";
        };
      };

      services.caddy = lib.mkIf config.services.miniflux.enable {
        # reactflux http://localhost:51832
        virtualHosts."http://:51832".extraConfig = ''
          root * ${pkgs.reactflux}
          try_files {path} {path}/ /index.html
          file_server
        '';
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
