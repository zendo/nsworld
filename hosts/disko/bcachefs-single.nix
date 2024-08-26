{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        device = lib.mkDefault "/dev/vda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              end = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi";
                mountOptions = [
                  "fmask=0022"
                  "dmask=0022"
                ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "bcachefs";
                mountpoint = "/";
                mountOptions = [ "compress=zstd" ];
              };
            };
          };
        };
      };
    };
  };
}
