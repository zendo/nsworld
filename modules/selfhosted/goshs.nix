{
  flake.modules.nixos.selfhosted =
    { config, lib, ... }:
    {
      # https://docs.goshs.de/usage/config/index.html
      services.goshs = {
        openFirewall = config.networking.firewall.enable;
        user = "${config.myVars.user}"; # dangerous!!!
        group = "users";
        settings = {
          # Required
          interface = "0.0.0.0";
          port = 8009;
          directory = lib.mkDefault "/data";
          uploadFolder = lib.mkDefault "/data";
          # Optional
          webdav = true;
          webdav_port = 8001;
        };
      };
    };
}
