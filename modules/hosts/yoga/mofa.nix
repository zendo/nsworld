{
  flake.modules.nixos.host-yoga =
    { pkgs, config, ... }:
    {
      environment.systemPackages = with pkgs; [
        mihomo
        sing-box
        # gui-for-singbox
        # gui-for-clash
      ];

      systemd.services.sub-store.enable = true;

      services.sing-box = {
        # enable = true;
        settings = {
          _secret = "/home/${config.myVars.user}/Projects/subs/config.jsonc";
          quote = false;
        };
      };

      services.mihomo = {
        enable = true;
        tunMode = true;
        webui = pkgs.zashboard;
        configFile = "/home/${config.myVars.user}/Projects/subs/config.yaml";
      };

      # services.daeWithConfig.enable = true;
      services.dae = {
        # enable = true;
        configFile = "/home/${config.myVars.user}/Projects/subs/dae-config.dae";
      };
    };
}
