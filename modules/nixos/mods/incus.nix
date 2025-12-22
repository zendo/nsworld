# https://wiki.nixos.org/wiki/Incus
{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.mods.incus.enable = lib.mkEnableOption "incus customize.";

  config = lib.mkIf config.mods.incus.enable {
    environment.systemPackages = with pkgs; [
      incus-ui-canonical
    ];

    virtualisation.incus = {
      enable = true;
      ui.enable = true;
      preseed = {
        config = {
          "core.https_address" = "[::]:8443";
        };
        networks = [
          {
            name = "incusbr0";
            type = "bridge";
            config = {
              "ipv4.address" = "10.0.100.1/24";
              "ipv4.nat" = true;
              # "ipv6.address" = "auto";
            };
          }
        ];
        storage_pools = [
          {
            config = {
              source = "/var/lib/incus/storage-pools/default";
            };
            driver = "dir";
            name = "default";
          }
        ];
        profiles = [
          {
            name = "default";
            devices = {
              eth0 = {
                name = "eth0";
                type = "nic";
                network = "incusbr0";
              };
              root = {
                path = "/";
                pool = "default";
                size = "25GB";
                type = "disk";
              };
            };
          }
        ];
      }; # end of preseed
    }; # end of virtualisation.incus
  }; # end of config
}
