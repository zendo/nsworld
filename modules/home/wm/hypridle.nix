{ ... }:
{
  services.hypridle = {
    enable = true;
  };

  xdg.configFile."hypridle".source = ../../../dotfiles/hypridle;
}
