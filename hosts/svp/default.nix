{
  inputs,
  self,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./bcachefs-single.nix

    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-gpu-intel

    self.nixosModules.gnome
    # self.nixosModules.kde
    # self.nixosModules.sway
    # self.nixosModules.hyprland
  ];

  services = {
    # btrfs.autoScrub.enable = true;
    displayManager.autoLogin.user = "${username}";
    # v2raya.enable = true;
  };

  mods = {
    # steam.enable = true;
    # daeWithConfig.enable = true;
  };

  programs = {
    # nix-ld.enable = true;

    clash-verge = {
      enable = true;
      tunMode = true;
      autoStart = true;
      package = pkgs.mihomo-party;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  ###############################################
  ## Bootloader
  ###############################################
  boot.loader = {
    efi.efiSysMountPoint = "/efi"; # default /boot
    systemd-boot.enable = true;
    grub = {
      # enable = true;
      device = "nodev";
      efiSupport = true;
      # Because this machine's efivars can't touch
      # It just move grubx64.efi -> Boot/bootx64.efi
      efiInstallAsRemovable = true;
      extraEntries = ''
          menuentry "Windows" {
           search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
           chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
          }

        #   menuentry "Arch Linux" {
        #    search --file --no-floppy --set=root /EFI/arch/grubx64.efi
        #    chainloader (''${root})/EFI/arch/grubx64.efi
        #   }
      '';
    };
  };

  ###############################################
  ## FileSystem
  ###############################################

  boot.supportedFilesystems = [
    "ntfs"
  ];

  # Swapfile
  # swapDevices = [
  #   {
  #     device = "/var/swapfile";
  #     size = 1024 * 8;
  #   }
  # ];
}
