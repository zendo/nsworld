{ ... }:
{
  programs.zellij = {
    # enable = true;
    settings = {
      theme = "nord";
      default_shell = "zsh";
      simplified_ui = true;
      pane_frames = false;
      keybinds = {
        unbind = "Ctrl q";
      };
    };
  };
}
