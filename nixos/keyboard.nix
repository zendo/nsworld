{
  ...
}:
{
  services = {
    # keyd: https://github.com/rvaiya/keyd
    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "overload(control, capslock)";
            };
          };
        };
      };
    };

    # kanata: https://github.com/jtroo/kanata
    kanata = {
      # enable = true;
      keyboards = {
        default.configFile = ../dotfiles/kanata/minimal.kbd;
      };
    };
  };
}
