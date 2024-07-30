{ config, pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "zsh";
      theme = "catppuccin-mocha";
      pane_frames = false;
      simplified_ui = true;
    };
  };
}
