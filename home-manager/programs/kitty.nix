{ pkgs, config, ... }:
{
  # xdg.configFile."kitty".source = ../../dotfiles/kitty;
  # xdg.configFile."kitty".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nsworld/dotfiles/kitty";

  # home.packages = with pkgs; [
  #   kitty
  #   kitten-quick-terminal # .desktop
  # ];

  # https://sw.kovidgoyal.net/kitty/conf
  # https://sw.kovidgoyal.net/kitty/_downloads/433dadebd0bf504f8b008985378086ce/kitty.conf
  programs.kitty = {
    # enable = true;
    # show right prompts
    shellIntegration.mode = "no-cursor no-sudo";
    # kitten theme
    themeFile = "zenbones_dark";
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
    settings = {
      shell = "zsh -l";
      # Theme
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
  };
}
