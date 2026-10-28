{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      services.navidrome = {
        # plugins = with pkgs.pkgsCross.wasi32.navidromePlugins; [
        #   lyrics-plugin
        #   listenbrainz-daily-playlist
        # ];
        openFirewall = config.networking.firewall.enable;
        settings = {
          Address = "0.0.0.0";
          Port = 4539;
          MusicFolder = "/data/media/music";
          DefaultLanguage = "zh-Hans";
          DefaultTheme = "AMusic";
        };
      };
    };
}
