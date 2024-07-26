{
  inputs,
  self,
  pkgs,
  ...
}:
{
  imports = [
    # ./disko-btrfs.nix
    ./disko-bcachefs.nix
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-gpu-intel

    self.nixosModules.gnome
    # self.nixosModules.kde
    # self.nixosModules.sway
    # self.nixosModules.hyprland
  ];

  ###############################################
  ## Mods
  ###############################################

  # mods.steam.enable = true;

  # programs.nix-ld.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  ###############################################
  ## Network
  ###############################################
  # mods.daeWithConfig.enable = true;

  programs.clash-verge = {
    enable = true;
    tunMode = true;
    autoStart = true;
    package = pkgs.clash-verge-rev;
  };

  # services.v2raya.enable = true;

  ###############################################
  ## Bootloader
  ###############################################
  boot.loader = {
    efi.efiSysMountPoint = "/efi";
    systemd-boot.enable = true;
    grub = {
      # enable = true;
      device = "nodev";
      efiSupport = true;
      # Because this machine's efivars can't touch
      # It just move grubx64.efi -> Boot/bootx64.efi
      efiInstallAsRemovable = true;
      # extraEntries = ''
      #   menuentry "Arch Linux" {
      #    search --file --no-floppy --set=root /EFI/arch/grubx64.efi
      #    chainloader (''${root})/EFI/arch/grubx64.efi
      #   }
      # '';
    };
  };

  ###############################################
  ## FileSystem
  ###############################################
  boot.supportedFilesystems = [
    "ntfs"
    "bcachefs"
  ];

  # Swapfile
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 1024 * 8;
    }
  ];
}
