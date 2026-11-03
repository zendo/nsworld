{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    let
      p = config.myVars.ports;
    in
    {
      services.homepage-dashboard = {
        openFirewall = config.networking.firewall.enable;
        listenPort = p.homepage;
        allowedHosts = "*";

        services = [
          {
            Selfhosted = [
              # {
              #   Navidrome = {
              #     href = "http://localhost:${toString p.navidrome}";
              #     description = "Music service";
              #   };
              # }
              {
                goshs = {
                  href = "http://localhost:${toString p.goshs}";
                  description = "File server";
                };
              }
              # {
              #   dufs = {
              #     href = "http://localhost:${toString p.dufs}";
              #     description = "File server";
              #   };
              # }
              {
                miniflux = {
                  href = "http://localhost:${toString p.miniflux}";
                  description = "Rss reader";
                };
              }
            ];
          }
        ];

      };
    };
}
