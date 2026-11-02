{
  flake.modules.nixos.selfhosted =
    { config, pkgs, ... }:
    {
      services.kavita = {
        settings = {
          IpAddresses = "127.0.0.1";
          Port = config.myVars.ports.kavita;
          # head -c 64 /dev/urandom | base64 --wrap=0
          TokenKey = pkgs.writeText
            "kavitaKeyFile"
            "RSNAYvtNYEuH9qKqQMmJYVI7IGQqcD25AYmhW82BlqHnh/qkq0FIHErXu/mUGMg0X1AbcYxucC1RPPDvlQAn9w==";
        };
      };
    };
}
