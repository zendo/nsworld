{ inputs, ... }:
{
  flake.modules.nixos.keyboards = {

    # https://github.com/jtroo/kanata
    services.kanata = {
      enable = true;
      keyboards = {
        default.configFile = (inputs.self + /dotfiles/kanata/minimal.kbd);
      };
    };

    # https://github.com/rvaiya/keyd
    # sudo nix run nixpkgs#keyd monitor
    services.keyd = {
      # enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "overload(control, capslock)";
            };
          }; # settings
        }; # default
      }; # keyboards
    }; # keyd

  };
}
