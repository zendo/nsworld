{
  flake.modules.nixos.services = {

    # https://github.com/rvaiya/keyd
    # sudo nix run nixpkgs#keyd monitor
    services.keyd = {
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
