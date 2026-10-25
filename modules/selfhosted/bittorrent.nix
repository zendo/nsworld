{
  flake.modules.nixos.selfhosted =
    { config, lib, ... }:
    {
      services.rqbit = {
        openFirewall = config.networking.firewall.enable;
        httpHost = "0.0.0.0";
        httpPort = 3039;
        downloadDir = "/data/temp";
      };

      # Allow rqbit to access downloadDir.
      users.users.rqbit.extraGroups = lib.optionals config.services.rqbit.enable [ "users" ];
      # Allow group members to modify downloaded files.
      systemd.services.rqbit.serviceConfig.UMask = lib.mkForce "0002";

      services.qui = {
        openFirewall = config.networking.firewall.enable;
        # secretFile = "";
        # settings = {
        #   port = 7779;
        # };
      };

      # services.aria2 = {
      #   enable = true;
      # };
    };
}
