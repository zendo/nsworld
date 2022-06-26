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

  boot.loader.systemd-boot.consoleMode = "max";

  # boot.loader.grub = {
  #   default = "2";
  #   useOSProber = true;
  #   gfxmodeEfi = "1024x768";
  # };
}
