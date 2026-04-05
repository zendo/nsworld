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
          _secret = "/home/${config.myVars.user}/code/subs/config.jsonc";
          quote = false;
        };
      };

      services.mihomo = {
        enable = true;
        tunMode = true;
        # webui = pkgs.zashboard;
        configFile = "/home/${config.myVars.user}/code/subs/config.yaml";
      };

      # services.daeWithConfig.enable = true;
      # services.dae = {
      #   enable = true;
      #   configFile = "/home/${myvars.user}/code/subs/dae-config.dae";
      # };

      # Virtual network interfering Geoclue2's IP-based location
      services.geoclue2 = {
        # enableStatic = true;
        staticAltitude = 10; # 海拔高度
        staticAccuracy = 1000; # 精度半径
      };
      location = {
        latitude = 23.38; # 纬度
        longitude = 113.20; # 经度
      };
    };
}
