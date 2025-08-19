{ ... }:
{
  # https://github.com/rvaiya/keyd
  services.keyd = {
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
}
