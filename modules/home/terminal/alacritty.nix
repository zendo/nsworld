# https://alacritty.org/config-alacritty.html
{ inputs, ... }:
let
  themeName = "tomorrow_night_bright";
in
{
  flake.modules.homeManager.alacritty =
    { pkgs, ... }:
    {
      programs.alacritty = {
        enable = true;
        package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.wrap-alacritty;
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.wrap-alacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
        inherit pkgs;
        settings = {
          general = {
            live_config_reload = false;
            import = [
              "${pkgs.alacritty-theme}/share/alacritty-theme/${themeName}.toml"
            ];
          };

          env = {
            TERM = "xterm-256color";
          };

          terminal.shell = {
            program = "zsh";
            args = [ "-l" ];
          };

          font = {
            size = 11;
            normal = {
              family = "JetBrains Mono";
            };
          };

          window = {
            dimensions = {
              columns = 90;
              lines = 30;
            };
            padding = {
              x = 6;
              y = 6;
            };
            opacity = 0.8;
            decorations = "None";
          };

          mouse.bindings = [
            {
              mouse = "Middle";
              action = "PasteSelection";
            }
          ];

          keyboard.bindings = [
            {
              key = "C";
              mods = "Control|Shift";
              action = "Copy";
            }
            {
              key = "V";
              mods = "Control|Shift";
              action = "Paste";
            }
            {
              key = "N";
              mods = "Control|Shift";
              action = "CreateNewWindow";
            }
            {
              key = "F11";
              action = "ToggleFullscreen";
            }
            # emacs keybindings style
            {
              key = "W";
              mods = "Alt";
              action = "Copy";
            }
            {
              key = "Y";
              mods = "Control";
              action = "Paste";
            }
            {
              key = "V";
              mods = "Control";
              action = "ScrollHalfPageDown";
            }
            {
              key = "V";
              mods = "Alt";
              action = "ScrollHalfPageUp";
            }
          ];
        };
      };
    };
}
