{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    let
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
                  href = "http://dashboard-host:${navidromePort}";
                  description = "Music service";
                };
              }
              {
                goshs = {
                  href = "http://dashboard-host:8009";
                  description = "File server";
                };
              }
              {
                dufs = {
                  href = "http://dashboard-host:${dufsPort}";
                  description = "File server";
                };
              }
              {
                comigo = {
                  href = "http://dashboard-host:1239";
                  description = "Comi reader";
                };
              }
              {
                sub-store = {
                  href = "http://dashboard-host:3009";
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
