{ config, pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "zsh";
      theme = "nord";
      pane_frames = false;
      simplified_ui = true;
    };
  };
}
