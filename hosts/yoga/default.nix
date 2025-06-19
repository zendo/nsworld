/*
  nixos/refind: init module #414394:
  https://github.com/NixOS/nixpkgs/pull/414394

  nixos/lemurs: init #329496:
  https://github.com/NixOS/nixpkgs/pull/329496
*/

{
  inputs,
  self,
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    # inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nixos-hardware.nixosModules.common-gpu-amd

    # self.nixosModules.gnome
    self.nixosModules.kde
    # self.nixosModules.cosmic
    # self.nixosModules.sway
    # self.nixosModules.niri
    # self.nixosModules.hyprland
  ];

  mods = {
    steam.enable = true;
    # virt.enable = true; # default: true
  };

  systemd = {
    services.sing-box.enable = true;
  };

  services = {
    # displayManager.autoLogin.user = "${username}";

    dae = {
      # enable = true;
      configFile = "/home/${username}/code/sub/dae-config.dae";
    };
    # daeWithConfig.enable = true;
  };

  programs = {
    # nix-ld.enable = true;

    clash-verge = {
      # enable = true;
      # autoStart = true;
    };
  };

  # environment.systemPackages = with pkgs; [
  #   inputs.nixpkgs-pr.legacyPackages.${system}.apps
  # ];

  ###############################################
  ## Hardware
  ###############################################

  # fix ax200 bluetooth randomly lose connectivity
  # hardware.enableAllFirmware = true;
  # nixpkgs.config.allowUnfree = true;

  # hardware.amdgpu.amdvlk.enable = true;

  boot = {
    # latest / zen / lqx / xanmod_latest
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      # Fixes for s2idle: https://www.phoronix.com/news/More-s2idle-Rembrandt-Linux
      # https://github.com/NixOS/nixos-hardware/blob/master/lenovo/yoga/7/14ARH7/shared.nix#L25
      "acpi.prefer_microsoft_dsm_guid=1"
    ];

    supportedFilesystems = [
      "ntfs"
    ];

    # https://fedoraproject.org/wiki/Changes/IncreaseVmMaxMapCount
    # kernel.sysctl = {
    #   "vm.max_map_count" = 2147483642; # default: 1048576
    # };

    # plymouth = {
    #   theme = "double";
    #   themePackages = [pkgs.adi1090x-plymouth-themes];
    # };

    # binfmt.emulatedSystems = [ "aarch64-linux" "riscv64-linux" ];
  };

  # Swapfile
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 1024 * 10;
    }
  ];

  # zramSwap.enable = lib.mkDefault true;

  ###############################################
  ## Bootloader
  ###############################################
  /*
    Disable "Secure Boot" and reset to “Setup Mode”
    sudo -i
    sbctl create-keys
    sbctl enroll-keys -m -f
  */
  # boot.lanzaboote = {
  #   enable = true;
  #   configurationLimit = 3;
  #   pkiBundle = "/etc/secureboot";
  #   # settings = {
  #   # };
  # };

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi"; # default /boot
    };
    ################
    ## Systemd-boot
    ################
    systemd-boot = {
      # enable = true;
      configurationLimit = 5; # bootmenu items
      consoleMode = "max";
      windows = {
        "nvme0n1p1" = {
          title = "Windows 11";
          # sudo blkid //check Windows ESP PARTUUID
          # reboot to systemd-boot uefi shell and type: map
          # find the FS alias match Windows ESP (ex: HD0a66666a2, HD0b, FS1, or BLK7)
          efiDeviceHandle = "FS0";
          sortKey = "a_windows";
        };
      };
    };
    ################
    ## Limine
    ################
    # https://wiki.archlinux.org/title/Limine
    # https://github.com/limine-bootloader/limine/blob/trunk/CONFIG.md
    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/loader/limine/limine.nix
    limine = {
      enable = true;
      maxGenerations = 8;
      secureBoot.enable = true;
      style.interface.branding = " ";
      # style.interface.helpHidden = true; # FIXME
      style.wallpapers = [
        # pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath
        # pkgs.nixos-artwork.wallpapers.gnome-dark.gnomeFilePath
        # pkgs.nixos-artwork.wallpapers.stripes-logo.gnomeFilePath
      ];
      extraConfig = ''
        interface_help_hidden: yes
      '';
      extraEntries = ''
        /Windows
            protocol: efi
            path: boot(1):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };
    ################
    ## GRUB2
    ################
    grub = {
      # enable = true;
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
        menuentry "Firmware" {
         fwsetup
        }
        menuentry "Shutdown" {
         halt
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
}
