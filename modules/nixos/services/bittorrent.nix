{
  flake.modules.nixos.bittorrent =
    { config, ... }:
    {
      services.rqbit = {
        enable = true;
        user = "${config.myVars.user}";
        downloadDir = "/home/${config.myVars.user}/Downloads";
        # httpHost = "127.0.0.1";
        # httpPort = 3030;
        openFirewall = config.networking.firewall.enable;
      };

      # services.qui = {
      #   enable = true;
      #   # secretFile = "";
      #   # settings = {
      #   #   port = 7777;
      #   # };
      #   openFirewall = config.networking.firewall.enable;
      # };
    };
}
