{
  inputs,
  self,
  pkgs,
  myvars,
  ...
}:
{
  imports = [
    # ./disko-bcachefs.nix
    ./disko-btrfs.nix
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-gpu-intel

    self.modules.nixos.default
    self.modules.nixos.laptop
    self.modules.nixos.hm

    # self.modules.nixos.gnome
    self.modules.nixos.kde
    # self.modules.nixos.cosmic
    # self.modules.nixos.niri
    # self.modules.nixos.sway
    # self.modules.nixos.hyprland
  ];

  mods.virt.enable = true;
  mods.incus.enable = true;
  # programs'.steam.enable = true;
  # programs'.nix-ld.enable = true;

  services.acpid.enable = true;
  # services.fwupd.enable = true;
  # services.displayManager.autoLogin.user = "${myvars.user}";

  users.users.${myvars.user} = {
    # pw: 123
    hashedPassword = "$y$j9T$HMRcTJOCJnmqDmH2cPVGF.$ZeGBjMnWDDpnicBGlVGZGNSkEXxdI7jLvm3GHK8eqVA";
  };

  # ╭──────────────────────────────────────────────────────────╮
  # │ HARDWARE                                                 │
  # ╰──────────────────────────────────────────────────────────╯
  boot = {
    # latest / zen / lqx / xanmod_latest
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "ntfs" ];
  };

  # Swapfile
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 1024 * 8;
    }
  ];

  zramSwap.enable = true;

  # ╭──────────────────────────────────────────────────────────╮
  # │ BOOTLOADER                                               │
  # ╰──────────────────────────────────────────────────────────╯
  boot.loader = {
    efi.efiSysMountPoint = "/efi";
    limine = {
      enable = true;
      style.wallpapers = [ ];
      style.interface.branding = " ";
    };
  };
}
