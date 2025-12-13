{ config, lib, ... }:
{
  config = lib.mkMerge [
    {
      programs.helix = {
        # enable = true;
      };
    }
    (lib.mkIf config.programs.helix.enable {
      xdg.configFile."helix".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nsworld/dotfiles/helix";
    })
  ];
}
