{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-intel
  ];

  # latest or zen or xanmod_latest
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # boot.loader = {
  #   efi.canTouchEfiVariables = true;
  #   efi.efiSysMountPoint = "/boot/efi"; # default /boot
  #   systemd-boot = {
  #     enable = true;
  #     configurationLimit = 5; # bootmenu items
  #   };
  # };

  # sudo mkdir /boot/efi/EFI/BOOT
  # sudo cp /boot/efi/EFI/NixOS-boot-efi/grubx64.efi /boot/efi/EFI/Boot/bootx64.efi
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi"; # default /boot
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      # default = "1";
      # gfxmodeEfi = "1024x768";
      # extraEntriesBeforeNixOS = true;
      # extraEntries = ''
      #   menuentry "Windows" {
      #     search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
      #    chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
      #   }
      # '';
    };
  };

  # ext4
  fileSystems."/".options = ["noatime" "nodiratime"];
}
