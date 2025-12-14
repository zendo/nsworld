{ ... }:
{
  services.hypridle = {
    enable = true;
  };

  xdg.configFile."hypridle".source = ../../../dotfiles/hypr/hypridle.conf;
}
