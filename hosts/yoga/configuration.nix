{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  # latest or zen or xanmod_latest
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # boot.kernelParams = ["quite"];

  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader = {
  #   # boot.efi.efiSysMountPoint = "/boot/efi"; # default /boot
  #   systemd-boot = {
  #     enable = true;
  #     configurationLimit = 5; # bootmenu items
  #     consoleMode = "max";
  #   };
  # };

  boot.loader = {
    # boot.efi.efiSysMountPoint = "/boot/efi"; # default /boot
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      # default = "1";
      gfxmodeEfi = "1024x768";
      extraEntriesBeforeNixOS = true;
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod chain
          set root=(hd0,gpt1)
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  # btrfs
  services.btrfs.autoScrub.enable = true;
  fileSystems."/".options = ["compress=zstd" "autodefrag" "noatime"];
}
