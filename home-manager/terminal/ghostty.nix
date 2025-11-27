{ pkgs, ... }:
{
  # https://ghostty.org/docs/config/reference
  # ghostty +show-config --default --docs
  programs.ghostty = {
    enable = true;
    settings = {
      command = "zsh --login";
      shell-integration-features = "no-cursor,sudo";
      # custom-shader = "${pkgs.ghostty-cursor-shaders}/cursor_warp.glsl";
      font-family = [
        "Maple mono"
        "Noto Sans SC"
      ];
      font-size = "11";
      cursor-style = "block";
      # theme = "Afterglow";
      background = "0F0F0F";
      # foreground = "F0F0F0";
      background-opacity = "0.9";
      gtk-titlebar = false;
      # gtk-wide-tabs = false;
      # window-width = "90";
      # window-height = "28";
      window-padding-x = "8";
      window-padding-y = "4";
      window-theme = "ghostty";
      # copy-on-select = "clipboard";
      keybind = [
        # "global:ctrl+grave_accent=toggle_quick_terminal"
        "global:super+comma=toggle_quick_terminal"
        "ctrl+enter=unbind"
        "f11=toggle_fullscreen"
        "alt+w=copy_to_clipboard"
        "ctrl+y=paste_from_clipboard"
        "ctrl+x>2=new_split:down"
        "ctrl+x>3=new_split:right"
        "ctrl+x>0=close_surface"
        "ctrl+shift+q=close_window"
        "ctrl+shift+backspace=close_surface"
      ];
    };
  };
}
