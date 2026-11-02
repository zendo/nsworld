{
  flake.modules.nixos.selfhosted =
    { config, lib, ... }:
    {
      # https://docs.goshs.de/usage/config/index.html
      services.goshs = {
        # openFirewall = config.networking.firewall.enable; # 由 Caddy 反代,不再直接放行
        user = "${config.myVars.user}"; # dangerous!!!
        group = "users";
        settings = {
          # Required
          interface = "127.0.0.1";
          port = config.myVars.ports.goshs;
          directory = lib.mkDefault "/data";
          uploadFolder = lib.mkDefault "/data";
          # Optional
          webdav = true;
          webdav_port = config.myVars.ports.webdav;
        };
      };
    };
}
