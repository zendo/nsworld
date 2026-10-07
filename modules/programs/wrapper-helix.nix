{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.wrapper-helix = inputs.omniflake.flakes.nix-wrapper-modules.wrappers.helix.wrap {
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
