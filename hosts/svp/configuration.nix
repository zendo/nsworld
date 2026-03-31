{
  inputs,
  self,
  pkgs,
  myvars,
  ...
}:
{
  imports =
    with self.modules.nixos;
    [
      # [ profiles ]
      hmModule
      default-imports
      laptop
      # steam

      # [ virt ]
      docker
      # incus
      # nix-ld
      qemu

      # [ desktop ]
      gnome
      # kde
      # cosmic
      # niri
      # sway
      # hyprland
    ]
    ++ [
      ./disko-btrfs.nix
      ./hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.common-gpu-intel
    ];

  home-manager.users.${myvars.user}.imports = [
    self.modules.homeManager.default-imports
  ];

  users.users.${myvars.user} = {
    # pw: 123
    hashedPassword = "$y$j9T$HMRcTJOCJnmqDmH2cPVGF.$ZeGBjMnWDDpnicBGlVGZGNSkEXxdI7jLvm3GHK8eqVA";
  };

  # ╭─────────────────────────────────────────────────────╮
  # │ HARDWARE                                            │
  # ╰─────────────────────────────────────────────────────╯
  boot.supportedFilesystems = [ "ntfs" ];

  zramSwap.enable = true;

  # Swapfile
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 1024 * 8;
    }
  ];

  # ╭─────────────────────────────────────────────────────╮
  # │ BOOTLOADER                                          │
  # ╰─────────────────────────────────────────────────────╯
  boot.loader = {
    efi.efiSysMountPoint = "/efi";
    limine = {
      enable = true;
      style.wallpapers = [ ];
      style.interface.branding = " ";
    };
  };
}
