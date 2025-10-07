{
  inputs,
  self,
  pkgs,
  config,
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
    self.nixosModules.laptopPowerPlan

    self.nixosModules.gnome
    # self.nixosModules.kde
    # self.nixosModules.cosmic
    # self.nixosModules.sway
    # self.nixosModules.niri
    # self.nixosModules.hyprland
  ];

  mods = {
    # steam.enable = true;
  };

  services = {
    acpid.enable = true;
    # fwupd.enable = true;
    btrfs.autoScrub.enable = true;

    displayManager.autoLogin.user = "${username}";
  };

  programs = {
    # nix-ld.enable = true;
  };

  users.users.${username} = {
    # 123
    hashedPassword = "$y$j9T$HMRcTJOCJnmqDmH2cPVGF.$ZeGBjMnWDDpnicBGlVGZGNSkEXxdI7jLvm3GHK8eqVA";
  };

  boot = {
    # latest / zen / lqx / xanmod_latest
    kernelPackages = pkgs.linuxPackages_latest;

    supportedFilesystems = [
      "ntfs"
    ];
  };

  ###############################################
  ## Bootloader
  ###############################################
  boot.loader = {
    efi.efiSysMountPoint = "/efi"; # default /boot
    limine.enable = true;
  };

  # Swapfile (bcachefs not support)
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 1024 * 8;
    }
  ];
}
