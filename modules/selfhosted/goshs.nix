{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      # https://docs.goshs.de/usage/config/index.html
      services.goshs = {
        openFirewall = config.networking.firewall.enable;
        user = "${config.myVars.user}"; # dangerous!!!
        group = "users";
        settings = {
          interface = "0.0.0.0";
          port = 8009;
          directory = "/data";
          uploadFolder = "/data";
          webdav = true;
          webdav_port = 8001;
        };
      };
    };
}
