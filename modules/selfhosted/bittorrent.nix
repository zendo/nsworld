{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      services.rqbit = {
        downloadDir = "/data/temp";
        # httpHost = "127.0.0.1";
        # httpPort = 3039;
        openFirewall = config.networking.firewall.enable;
      };

      services.qui = {
        # secretFile = "";
        # settings = {
        #   port = 7779;
        # };
        openFirewall = config.networking.firewall.enable;
      };

      # services.aria2 = {
      #   enable = true;
      # };
    };
}
