{
  flake.modules.nixos.selfhosted =
    { config, lib, ... }:
    {
      services.navidrome = {
        # plugins = with pkgs.pkgsCross.wasi32.navidromePlugins; [
        #   lyrics-plugin
        #   listenbrainz-daily-playlist
        # ];
        # openFirewall = config.networking.firewall.enable; # 由 Caddy 反代,不再直接放行
        settings = {
          Address = "127.0.0.1";
          Port = config.myVars.ports.navidrome;
          MusicFolder = lib.mkDefault "/data/media/music";
          DefaultLanguage = "zh-Hans";
          DefaultTheme = "AMusic";
        };
      };
    };
}
