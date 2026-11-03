{
  flake.modules.nixos.selfhosted =
    { config, lib, ... }:
    {
      services.dufs = {
        user = "${config.myVars.user}"; # dangerous!!!
        group = "users";
        servePath = lib.mkDefault "/data";
        bindAddresses = [ "127.0.0.1" ];
        port = config.myVars.ports.dufs;
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
