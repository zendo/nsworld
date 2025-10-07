{ ... }:
{
  # ghostty +show-config --default --docs
  programs.ghostty = {
    # enable = true;
    settings = {
      command = "zsh --login";
      shell-integration-features = "no-cursor,sudo";
      font-family = "Maple mono";
      font-size = "11";
      # theme = "Tomorrow Night";
      background = "0F0F0F";
      # foreground = "F0F0F0";
      background-opacity = "0.9";
      window-height = "28";
      window-width = "90";
      window-padding-x = "8";
      window-padding-y = "4";
      cursor-style = "block";
      # copy-on-select = "clipboard";
      keybind = [
        "ctrl+enter=unbind"
        "f11=toggle_fullscreen"
        "alt+w=copy_to_clipboard"
        "ctrl+y=paste_from_clipboard"
        "ctrl+x>2=new_split:down"
        "ctrl+x>3=new_split:right"
        "ctrl+x>0=close_window"
        "ctrl+shift+q=close_window"
        "ctrl+shift+backspace=close_window"
      ];
    };
  };
}
