{
  flake.modules.nixos.samba =
    { config, pkgs, ... }:
    {
      # https://wiki.nixos.org/wiki/Samba
      # sudo smbpasswd -a $(id -un)
      services.samba = {
        enable = true;
        # package = pkgs.samba4Full;
        openFirewall = true;

        settings = {
          global = {
            "server role" = "standalone server";
            "security" = "user";
            "map to guest" = "never";
            "server min protocol" = "SMB2_10";
          };

          shared = {
            path = "/data/shared";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "valid users" = "${config.myVars.user}";
            "force group" = "users";
            "create mask" = "0660";
            "directory mask" = "0770";
          };

          media = {
            path = "/data/media";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "valid users" = "${config.myVars.user}";
            "force group" = "users";
            "create mask" = "0660";
            "directory mask" = "0770";
          };
        };
      };
    };
}
