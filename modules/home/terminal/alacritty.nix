{ ... }:
{
  # https://alacritty.org/config-alacritty.html
  programs.alacritty = {
    enable = true;
    theme = "tomorrow_night_bright";
    settings = {

      general = {
        live_config_reload = false;
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
        opacity = 0.9;
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
}
