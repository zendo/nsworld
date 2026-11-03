{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      services.beszel.hub = {
        host = "127.0.0.1";
        port = config.myVars.ports.beszel;
      };

      # services.grafana = {
      #   enable = true;
      #   settings = {
      #     server = {
      #       http_addr = "127.0.0.1";
      #       http_port = 3019;
      #     };
      #     security.secret_key = "123";
      #   };
      # };

    };
}
