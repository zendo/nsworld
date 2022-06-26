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

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
    # boot.efi.efiSysMountPoint = "/boot/efi"; # default /boot
    systemd-boot = {
      enable = true;
      configurationLimit = 5; # bootmenu items
      consoleMode = "max";
    };
  };

  # boot.loader = {
  #   boot.efi.efiSysMountPoint = "/boot/efi"; # default /boot
  #   grub = {
  #     enable = true;
  #     device = "nodev";
  #     efiSupport = true;
  #     default = "2";
  #     useOSProber = true;
  #     gfxmodeEfi = "1024x768";
  #   };
  # };

  # btrfs
  services.btrfs.autoScrub.enable = true;
  fileSystems."/".options = ["compress=zstd" "autodefrag" "noatime"];
}
