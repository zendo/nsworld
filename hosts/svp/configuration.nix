{
  inputs,
  self,
  pkgs,
  username,
  ...
}:
{
  imports = [
    # ./bcachefs-single.nix
    ./btrfs-subvolumes.nix
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-gpu-intel

    self.nixosModules.default
    self.nixosModules.homeManagerInit
    self.nixosModules.laptopPowerPlans

    self.nixosModules.gnome
    # self.nixosModules.kde
    # self.nixosModules.cosmic
    # self.nixosModules.sway
    # self.nixosModules.niri
    # self.nixosModules.hyprland
  ];

  mods.virt.enable = true;
  # mods.steam.enable = true;
  # programs.nix-ld.enable = true;

  services.acpid.enable = true;
  # services.fwupd.enable = true;
  services.displayManager.autoLogin.user = "${username}";

  users.users.${username} = {
    # pw: 123
    hashedPassword = "$y$j9T$HMRcTJOCJnmqDmH2cPVGF.$ZeGBjMnWDDpnicBGlVGZGNSkEXxdI7jLvm3GHK8eqVA";
  };

  # =========================================================================
  # Hardware
  # =========================================================================
  boot = {
    # latest / zen / lqx / xanmod_latest
    kernelPackages = pkgs.linuxPackages_latest;

    supportedFilesystems = [
      "ntfs"
    ];
  };

  # Swapfile
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 1024 * 8;
    }
  ];
  # =========================================================================
  # Bootloader
  # =========================================================================
  boot.loader = {
    efi.efiSysMountPoint = "/efi";
    limine = {
      enable = true;
      style.wallpapers = [ ];
      style.interface.branding = " ";
    };
  };
}
