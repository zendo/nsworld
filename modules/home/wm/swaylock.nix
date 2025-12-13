{ pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
  };
  xdg.configFile."swaylock".source = ../../../dotfiles/swaylock;
}
