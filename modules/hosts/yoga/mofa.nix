{
  flake.modules.nixos.host-yoga =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        mihomo
        sing-box
        zashboard
        # gui-for-singbox
        # gui-for-clash
      ];

      networking.firewall = {
        # mihomo 给 LAN 里其它设备当代理用。UDP 也得开,mixed-port 同时提供 UDP relay。
        allowedTCPPorts = [ 7890 ];
        allowedUDPPorts = [ 7890 ];
      };

      services.sing-box = {
        # enable = true;
        settings = {
          _secret = "/home/${config.myVars.user}/Projects/subs/config.jsonc";
          quote = false;
        };
      };

      services'.mihomo = {
        enable = true;
        tunMode = true;
        webui = pkgs.zashboard;
        configFile = "/home/${config.myVars.user}/Projects/subs/config.yaml";
      };

      # services.daeWithConfig.enable = true;
      # or
      services.dae = {
        # enable = true;
        configFile = "/home/${config.myVars.user}/Projects/subs/dae-config.dae";
      };
    };
}
