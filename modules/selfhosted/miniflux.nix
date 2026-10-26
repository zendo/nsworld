{
  flake.modules.nixos.selfhosted =
    { config, pkgs, ... }:
    let
      keyFile = pkgs.writeText "minifluxKeyFile" ''
        ADMIN_USERNAME=demo
        ADMIN_PASSWORD=123456
      '';
    in
    {
      services.miniflux = {
        adminCredentialsFile = keyFile;
        config = {
          LISTEN_ADDR = "0.0.0.0:8081";
        };
      };
    };
}
