{ config, pkgs, lib, inputs, ... }: {

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote # Secure Boot

    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    # inputs.nixos-hardware.nixosModules.common-gpu-amd
    # inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    # cpupower frequency-info
    # cat /sys/devices/system/cpu/cpufreq/policy0/scaling_driver
    # ls /sys/devices/system/cpu/cpu0/   :show CPPCCPPC
  ];

  # AMD GPU Temporary
  services.xserver.videoDrivers = lib.mkDefault [ "amdgpu" ];

  hardware.opengl = {
    driSupport = lib.mkDefault true;
    driSupport32Bit = lib.mkDefault true;
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  #######################################################################
  ## Kernel
  #######################################################################
  # latest or zen or xanmod_latest
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # boot.kernelParams = ["quite"];

  # boot.plymouth = {
  #   theme = "double";
  #   themePackages = [pkgs.adi1090x-plymouth-themes];
  # };

  # services.logind = {
  #   lidSwitch = "suspend-then-hibernate";
  #   extraConfig = ''
  #     HandlePowerKey=suspend-then-hibernate
  #     IdleAction=suspend-then-hibernate
  #     IdleActionSec=2m
  #   '';
  # };
  # systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  #######################################################################
  ## Bootloader
  #######################################################################
  /*
    Disable Secure Boot & reset to Setup Mode
    sudo -i
    sbctl create-keys
    After nixos bootup:
    sbctl enroll-keys --microsoft
  */
  boot.lanzaboote = {
    enable = true;
    configurationLimit = 5;
    pkiBundle = "/etc/secureboot";
  };

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi"; # default /boot
    };
    systemd-boot = {
      enable = false;
      configurationLimit = 5; # bootmenu items
      consoleMode = "max";
    };
    grub = {
      enable = false;
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
  fileSystems."/".options = [ "compress=zstd" "autodefrag" "noatime" ];
  # fileSystems = {
  #   "/".options = [ "compress=zstd" ];
  #   "/home".options = [ "compress=zstd" ];
  #   "/nix".options = [ "compress=zstd" "noatime" ];
  #   "/swap".options = [ "noatime" ];
  # };

  # Swapfile
  # https://github.com/NixOS/nixpkgs/pull/194343
  swapDevices = [{
    device = "/var/swapfile";
    size = (1024 * 8);
  }];
  # findmnt -no UUID -T /swap/swapfile
  # sudo filefrag -v /swap/swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}'
  # boot.resumeDevice = "/dev/disk/by-uuid/a0e48512-1e47-409d-9c91-7bbca721dbfc";
  # boot.kernelParams = [ # "mem_sleep_default=deep"
  #                       "resume_offset=42166446" ];
}
