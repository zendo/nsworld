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

  #######################################################################
  ## Kernel
  #######################################################################
  # latest or zen or xanmod_latest
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #######################################################################
  ## Bootloader
  #######################################################################
  # boot.loader = {
  #   efi.canTouchEfiVariables = true;
  #   efi.efiSysMountPoint = "/boot/efi"; # default /boot
  #   systemd-boot.enable = true;
  # };

  boot.loader = {
    # efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi"; # default /boot
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      # Because efivars can't touch
      # It just move grubx64.efi -> Boot/bootx64.efi
      efiInstallAsRemovable = true;
    };
  };

  #######################################################################
  ## FileSystem
  #######################################################################
  fileSystems."/".options = ["noatime" "nodiratime"];
}
