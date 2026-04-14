{ inputs, ... }:
{
  flake.modules.homeManager.mpv =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkMerge [
        {
          programs.mpv = {
            enable = true;
            package = (
              pkgs.mpv.override {
                youtubeSupport = false; # (yt-dlp)
                scripts = with pkgs.mpvScripts; [
                  mpris
                  # uosc
                  inhibit-gnome
                  thumbfast
                  modernz
                ];
              }
            );
          };
        }

        (lib.mkIf config.programs.mpv.enable {
          xdg.configFile."mpv".source =
            config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nsworld/dotfiles/mpv";
        })
      ];
    };
}
