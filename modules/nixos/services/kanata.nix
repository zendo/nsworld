{ inputs, ... }:
{
  flake.modules.nixos.services =
    { ... }:
    {
      # https://github.com/jtroo/kanata
      services.kanata = {
        enable = true;
        keyboards = {
          default.configFile = (inputs.self + /dotfiles/kanata/minimal.kbd);
        };
      };
    };
}
