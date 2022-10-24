{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    # inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    # cpupower frequency-info
    # cat /sys/devices/system/cpu/cpufreq/policy0/scaling_driver
    # ls /sys/devices/system/cpu/cpu0/   :show CPPCCPPC
  ];

  #######################################################################
  ## Kernel
  #######################################################################
  # latest or zen or xanmod_latest
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # boot.kernelParams = ["quite"];

  boot.plymouth = {
    theme = "double";
    themePackages = [pkgs.adi1090x-plymouth-themes];
  };

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
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi"; # default /boot
    };
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
      # theme = pkgs.fetchzip {
      # https://github.com/AdisonCavani/distro-grub-themes
      #   url = "https://raw.githubusercontent.com/AdisonCavani/distro-grub-themes/master/themes/freeBSD.tar";
      #   hash = "sha256-oTrh+5g73y/AXSR+MPz6a25KyCKCPLL8mZCDup/ENZc=";
      #   stripRoot=false;
      # };
    };
  };

  #######################################################################
  ## FileSystem
  #######################################################################
  services.btrfs.autoScrub.enable = true;
  fileSystems."/".options = ["compress=zstd" "autodefrag" "noatime"];
}
