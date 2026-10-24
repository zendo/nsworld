{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      services.homepage-dashboard = {
        openFirewall = config.networking.firewall.enable;
        listenPort = 8080;
        allowedHosts = "*";

        services = [
          {
            Selfhosted = [
              {
                Navidrome = {
                  href = "http://dashboard-host:4533";
                  description = "Music service";
                };
              }
              {
                goshs = {
                  href = "http://dashboard-host:8002";
                  description = "File server";
                };
              }
              {
                dufs = {
                  href = "http://dashboard-host:5001";
                  description = "File server";
                };
              }
              {
                comigo = {
                  href = "http://dashboard-host:1234";
                  description = "Comi reader";
                };
              }
              {
                sub-store = {
                  href = "http://dashboard-host:3000";
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
