{
  flake.modules.nixos.selfhosted =
    { config, pkgs, ... }:
    {
      services.caddy = {

        # reactflux http://localhost:51832
        virtualHosts."http://:51832".extraConfig = ''
          root * ${pkgs.reactflux}
          try_files {path} {path}/ /index.html
          file_server
        '';

      };
    };
}
