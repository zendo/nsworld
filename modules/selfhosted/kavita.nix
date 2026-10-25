{
  flake.modules.nixos.selfhosted =
    { config, pkgs, ... }:
    let
      # head -c 64 /dev/urandom | base64 --wrap=0
      keyFile = pkgs.writeText "kavitaKeyFile" "RSNAYvtNYEuH9qKqQMmJYVI7IGQqcD25AYmhW82BlqHnh/qkq0FIHErXu/mUGMg0X1AbcYxucC1RPPDvlQAn9w==";
    in
    {
      services.kavita = {
        tokenKeyFile = keyFile;
        settings = {
          Port = 5009;
        };
      };
    };
}
