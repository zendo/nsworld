{ self, ... }:
{
  # https://github.com/jtroo/kanata
  services.kanata = {
    enable = true;
    keyboards = {
      default.configFile = (self + /dotfiles/kanata/minimal.kbd);
    };
  };
}
