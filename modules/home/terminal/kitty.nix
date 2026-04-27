# https://sw.kovidgoyal.net/kitty/conf
# https://sw.kovidgoyal.net/kitty/_downloads/433dadebd0bf504f8b008985378086ce/kitty.conf
{ inputs, ... }:
{
  flake.modules.homeManager.kitty =
    { pkgs, ... }:
    {
      programs.kitty = {
        enable = true;
        package = pkgs.wrap-kitty;
      };
    };

  perSystem =
    { pkgs, ... }:
    let
      theme-mountain = pkgs.writeText "Mountain.conf" ''
        cursor #f0f0f0
        cursor_text_color #ffffff

        foreground            #f0f0f0
        background            #0f0f0f
        selection_foreground  #262626
        selection_background  #f0f0f0
        url_color             #9ec3c4

        # black
        color8  #777777
        color0  #4c4c4c

        # red
        color1  #ac8a8c
        color9  #c49ea0

        # green
        color2  #CCFF90
        color10 #9ec49f

        # yellow
        color3  #aca98a
        color11 #c4c19e

        # blue
        color4  #8f8aac
        color12 #a39ec4

        # magenta
        color5  #ac8aac
        color13 #c49ec4

        # cyan
        color6  #8aacab
        color14 #9ec3c4

        # white
        color15 #e7e7e7
        color7  #f0f0f0
      '';
    in
    {
      packages.wrap-kitty = inputs.wrapper-modules.wrappers.kitty.wrap {
        inherit pkgs;
        # Afterglow / vague / bl1nk
        # themeFile = "bl1nk";
        settings = {
          # shell = "zsh -l";
          # MAYBE
          # show right prompts
          shell_integration = "no-cursor no-sudo";
          # Theme
          include = "${theme-mountain}";
          background_opacity = "0.9";
          wayland_titlebar_color = "background";
          hide_window_decorations = "yes";
          # Fonts: JetBrains Mono / Maple Mono
          font_family = "Maple Mono";
          font_size = "11";
          # 禁用连字
          disable_ligatures = "always";
          font_features = "JetBrains Mono -liga";
          # Window
          initial_window_width = 800;
          initial_window_height = 600;
          window_padding_width = 5;
          remember_window_size = "no";
          confirm_os_window_close = "0";
          # Tab
          tab_bar_edge = "top";
          tab_bar_style = "powerline";
          tab_powerline_style = "round";
          # Cursor
          cursor_shape = "block";
          cursor_trail = 3;
          # Scrollback
          scrollback_lines = 3000;
          # Bell
          enable_audio_bell = "no";
          # visual_bell_color = "red";
          # window_alert_on_bell = "yes";
          # bell_on_tab = "🔔 ";
        };
        keybindings = {
          "f11" = "toggle_fullscreen";
          "alt+w" = "copy_to_clipboard";
          "ctrl+y" = "paste_from_clipboard";
          "alt+v" = "scroll_page_up";
          "ctrl+shift+v" = "scroll_page_down";
          "ctrl+shift+backspace" = "close_window";
          # "ctrl+z>2" = "new_window";
          # "ctrl+z>x" = "swap_with_window";
        };
      };
    };
}
