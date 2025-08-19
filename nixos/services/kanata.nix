{ ... }:
{
  # https://github.com/jtroo/kanata
  services.kanata = {
    # enable = true;
    keyboards = {
      default.configFile = ../../dotfiles/kanata/minimal.kbd;
    };
  };
}
