{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    let
      hostIP = config.myVars.ip.yoga; # or "dashboard-host"
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
              #     href = "http://${hostIP}:${toString p.navidrome}";
              #     description = "Music service";
              #   };
              # }
              {
                goshs = {
                  href = "http://${hostIP}:${toString p.goshs}";
                  description = "File server";
                };
              }
              # {
              #   dufs = {
              #     href = "http://${hostIP}:${toString p.dufs}";
              #     description = "File server";
              #   };
              # }
              {
                miniflux = {
                  href = "http://${hostIP}:${toString p.miniflux}";
                  description = "Rss reader";
                };
              }
            ];
          }
        ];

        customJS = ''
          // Replace the placeholder hostname in service links with the current page's hostname.
          (() => {
            const updateLinks = () => {
              document.querySelectorAll('a[href*="dashboard-host"]').forEach((link) => {
                const url = new URL(link.href);
                url.hostname = window.location.hostname;
                link.href = url.href;
              });
            };

            updateLinks();

            new MutationObserver(updateLinks).observe(document.body, {
              childList: true,
              subtree: true,
            });
          })();
        '';
      };
    };
}
