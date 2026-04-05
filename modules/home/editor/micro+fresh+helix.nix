{
  flake.modules.homeManager.micro = {
    programs.micro = {
      enable = true;
      settings = {
        autosu = true;
        softwrap = true;
        hlsearch = true;
        saveundo = true;
        scrollbar = true;
        mkparents = true;
        diffgutter = true;
      };
    };
  };

  flake.modules.homeManager.fresh-editor = {
    programs.fresh-editor = {
      enable = true;
      # settings = { };
    };
  };

  flake.modules.homeManager.helix =
    { config, lib, ... }:
    {
      config = lib.mkMerge [
        {
          programs.helix = {
            enable = true;
          };
        }
        (lib.mkIf config.programs.helix.enable {
          xdg.configFile."helix".source =
            config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nsworld/dotfiles/helix";
        })
      ];
    };
}
