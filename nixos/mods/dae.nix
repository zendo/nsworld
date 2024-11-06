{ lib, config, ... }:
let
  cfg = config.mods.daeWithConfig;
in
{
  options.mods.daeWithConfig = {
    enable = lib.mkEnableOption ''
        my dae encryption config.
      '';
  };

  config = lib.mkIf cfg.enable {
    services.dae = {
      enable = true;
      # configFile = "/home/iab/dev/config.dae";
      configFile = config.sops.templates."config.dae".path;
    };

    sops.secrets = {
      dae-sub = { };
    };

    sops.templates."config.dae".content = ''
      global {
        wan_interface: auto

        log_level: info
        allow_insecure: false
        auto_config_kernel_parameter: true
        # auto_config_firewall_rule: true
          }

      subscription {
        airport: '${config.sops.placeholder."dae-sub"}'
      }

      # 更多的 DNS 样例见 https://github.com/daeuniverse/dae/blob/main/docs/en/configuration/dns.md
      dns {
        upstream {
          googledns: 'tcp+udp://dns.google:53'
          alidns: 'udp://dns.alidns.com:53'
        }
        routing {
          request {
            fallback: alidns
          }
          response {
            upstream(googledns) -> accept
            ip(geoip:private) && !qname(geosite:cn) -> googledns
            fallback: accept
          }
        }
      }

      group {
        proxy {
          #filter: name(keyword: HK, keyword: SG)
          policy: min_moving_avg
        }
      }

      # 更多的 Routing 样例见 https://github.com/daeuniverse/dae/blob/main/docs/en/configuration/routing.md
      routing {
        pname(NetworkManager) -> direct
        dip(224.0.0.0/3, 'ff00::/8') -> direct

        ### 以下为自定义规则

        # 禁用 h3，因为它通常消耗很多 CPU 和内存资源
        l4proto(udp) && dport(443) -> block
        dip(geoip:private) -> direct
        dip(geoip:cn) -> direct
        domain(geosite:cn) -> direct

        fallback: proxy
      }
    '';
  };
}
