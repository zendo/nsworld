{ inputs, ... }:
{
  flake.modules.nixos.kanata = {
    # https://github.com/jtroo/kanata
    services.kanata = {
      enable = true;
      keyboards = {
        default.configFile = (inputs.self + /dotfiles/kanata/minimal.kbd);
      };
    };
  };
}
