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

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader = {
    # boot.efi.efiSysMountPoint = "/boot/efi"; # default /boot
    systemd-boot = {
      enable = true;
      configurationLimit = 5; # bootmenu items
    };
  };
}
