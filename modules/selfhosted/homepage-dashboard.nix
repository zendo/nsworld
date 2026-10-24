{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    let
      hostIP = "192.168.2.218"; # or "dashboard-host"
      dufsPort = (toString config.services.dufs.port);
      memosPort = (toString config.services.memos.settings.MEMOS_PORT);
      navidromePort = (toString config.services.navidrome.settings.Port);
    in
    {
      services.homepage-dashboard = {
        openFirewall = config.networking.firewall.enable;
        listenPort = 8089;
        allowedHosts = "*";

        services = [
          {
            Selfhosted = [
              {
                Navidrome = {
                  href = "http://${hostIP}:${navidromePort}";
                  description = "Music service";
                };
              }
              {
                goshs = {
                  href = "http://${hostIP}:8009";
                  description = "File server";
                };
              }
              # {
              #   dufs = {
              #     href = "http://${hostIP}:${dufsPort}";
              #     description = "File server";
              #   };
              # }
              {
                miniflux = {
                  href = "http://${hostIP}:8088";
                  description = "Rss reader";
                };
              }
              {
                comigo = {
                  href = "http://${hostIP}:1239";
                  description = "Comi reader";
                };
              }
              {
                sub-store = {
                  href = "http://${hostIP}:3009";
                  description = "Sub store";
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
