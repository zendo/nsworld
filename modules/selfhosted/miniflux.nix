{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      services.miniflux = {
        adminCredentialsFile = "/etc/miniflux-admin-credentials";
        config = {
          LISTEN_ADDR = "0.0.0.0:8081";
        };
      };

      environment.etc."miniflux-admin-credentials".text = ''
        ADMIN_USERNAME=admin
        ADMIN_PASSWORD=123456
      '';
    };
}
