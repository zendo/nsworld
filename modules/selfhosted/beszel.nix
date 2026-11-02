{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      services.beszel.hub = {
        host = "127.0.0.1";
        port = config.myVars.ports.beszel;
      };

      # agent 与 hub 在同一台机器,走 127.0.0.1,不需要开端口
      # services.beszel.agent.openFirewall = true;

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
