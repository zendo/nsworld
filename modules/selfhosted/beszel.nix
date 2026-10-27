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
    };
}
