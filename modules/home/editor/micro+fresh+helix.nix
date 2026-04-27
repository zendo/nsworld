{ inputs, ... }:
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
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.wrap-helix
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.wrap-helix = inputs.wrapper-modules.wrappers.helix.wrap {
        inherit pkgs;
        settings = {
          # everforest_dark / onedark
          theme = "everforest_dark";
          editor = {
            cursorline = true; # highlight current line
            true-color = true;
            auto-format = true;
            indent-guides.render = true;
            file-picker.hidden = true;

            lsp = {
              display-inlay-hints = true;
            };
          }; # editor
        }; # settings
      }; # packages
    };
}
