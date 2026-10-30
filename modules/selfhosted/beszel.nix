{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      services.beszel.hub = {
        host = "0.0.0.0";
        port = 8099;
      };

      services.beszel.agent = {
        openFirewall = config.networking.firewall.enable;
      };

      # services.grafana = {
      #   enable = true;
      #   settings = {
      #     server = {
      #       http_addr = "0.0.0.0";
      #       http_port = 3019;
      #     };
      #     security.secret_key = "123";
      #   };
      # };

    };
}
