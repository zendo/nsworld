{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      services.dufs = {
        user = "${config.myVars.user}"; # dangerous!!!
        group = "users";
        servePath = "/data";
        bindAddresses = [ "0.0.0.0" ];
        port = 5009;
        openFirewall = config.networking.firewall.enable;
        settings = {
          allow-upload = true;
          allow-delete = true;
          allow-archive = true;
          allow-symlink = false;
          # compress = "low";
          # hidden = [ "*.tmp" ];
          # auth = [ "demo:demo@/:rw" ];
        };
      };
    };
}
