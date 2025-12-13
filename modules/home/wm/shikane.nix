{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wdisplays
    shikane
  ];

  # wdisplays set the right outputs
  # install -Dm644 /dev/null ~/.config/shikane/config.toml
  # shikane
  # shikanectl export "host"
  services.shikane = {
    enable = true;
  };

  xdg.configFile."shikane".source = ../../../dotfiles/shikane;
}
