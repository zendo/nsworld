{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      services.beszel.hub = {
        host = "0.0.0.0";
        port = 8099;
      };

      services.beszel.agent = {
        openFirewall = config.networking.firewall.enable;
        environment = {
          KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+TKipwAtOLgUUrHIXNb5AYxDNc1E63ELFT4XNOZlXF";
        };
      };

    };
}
