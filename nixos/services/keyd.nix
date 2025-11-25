{ ... }:
{
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
        };
      };
    };
  };
}
