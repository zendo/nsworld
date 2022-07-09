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

  #######################################################################
  ## Kernel
  #######################################################################
  # latest or zen or xanmod_latest
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # boot.kernelParams = ["quite"];

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=2m
    '';
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  #######################################################################
  ## Bootloader
  #######################################################################
  # boot.loader = {
  #   efi.canTouchEfiVariables = true;
  #   # efi.efiSysMountPoint = "/boot/efi"; # default /boot
  #   systemd-boot = {
  #     enable = true;
  #     configurationLimit = 5; # bootmenu items
  #     consoleMode = "max";
  #   };
  # };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi"; # default /boot
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      gfxmodeEfi = "1024x768";
      default = "1";
      # extraEntriesBeforeNixOS = true;
      extraEntries = ''
        menuentry "Windows" {
          search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
         chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  #######################################################################
  ## FileSystem
  #######################################################################
  services.btrfs.autoScrub.enable = true;
  fileSystems."/".options = ["compress=zstd" "autodefrag" "noatime"];
}
