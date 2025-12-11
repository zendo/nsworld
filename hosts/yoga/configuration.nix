{
  inputs,
  self,
  lib,
  pkgs,
  myvars,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    # inputs.lanzaboote.nixosModules.lanzaboote

    self.nixosModules.default
    self.nixosModules.laptop
    self.nixosModules.homeManagerInit

    self.nixosModules.gnome
    # self.nixosModules.kde
    # self.nixosModules.cosmic
    # self.nixosModules.sway
    # self.nixosModules.niri
    # self.nixosModules.hyprland
  ];

  mods.virt.enable = true;
  # programs'.steam.enable = true;
  # programs'.nix-ld.enable = true;
  programs.command-not-found = {
    # enable = true;
    dbPath = inputs.nixpkgs + "/programs.sqlite";
  };

  services.acpid.enable = true;
  services.fwupd.enable = true;
  # services.displayManager.autoLogin.user = "${myvars.user}";

  security.sudo.wheelNeedsPassword = false;
  security.sudo-rs.wheelNeedsPassword = false;

  # ╭──────────────────────────────────────────────────────────╮
  # │ PROXY                                                    │
  # ╰──────────────────────────────────────────────────────────╯
  environment.systemPackages = with pkgs; [
    # inputs.nixpkgs-pr.legacyPackages.${stdenv.hostPlatform.system}.apps
    inputs.nix-alien.packages.${stdenv.hostPlatform.system}.nix-alien
    mihomo
    sing-box
    gui-for-singbox
    # gui-for-clash
    # v2rayn
    # flclash
    # (makeAutostartItem {
    #   name = "flclash";
    #   package = flclash;
    # })
    # pandora-box
    # (makeAutostartItem {
    #   name = "pandora-box";
    #   package = pandora-box;
    # })
    # (makeAutostartItem {
    #   name = "throne";
    #   package = throne;
    # })
  ];

  systemd.services.sub-store.enable = true;

  # services'.sing-box.enable = true;

  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.zashboard;
    configFile = "/home/${myvars.user}/code/subs/config.yaml";
  };

  # services.daeWithConfig.enable = true;
  services.dae = {
    # enable = true;
    configFile = "/home/${myvars.user}/code/subs/dae-config.dae";
  };

  programs.throne = {
    # enable = true;
    tunMode.enable = true;
  };

  programs.clash-verge = {
    # enable = true;
    autoStart = true;
    serviceMode = true;
  };

  programs.sparkle = {
    # enable = true;
    autoStart = true;
    tunMode = true;
  };

  # Virtual network interfering Geoclue2's IP-based location
  services.geoclue2 = {
    # enableStatic = true;
    staticAltitude = 10; # 海拔高度
    staticAccuracy = 1000; # 精度半径
  };
  location = {
    latitude = 23.38; # 纬度
    longitude = 113.20; # 经度
  };

  # ╭──────────────────────────────────────────────────────────╮
  # │ HARDWARE                                                 │
  # ╰──────────────────────────────────────────────────────────╯
  # Fix touhpad multitouch somtimes unavailable
  # sudo modprobe -r hid-multitouch && sudo modprobe hid-multitouch
  services.sleep-resume.hid-multitouch.enable = true;

  boot = {
    # latest / zen / lqx / xanmod_latest
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "ntfs" ];

    # Disable power management for "Intel AX200" driver
    # https://github.com/zachlatta/nixos-configs/blob/master/bak/lugia/intel_ax200_fix.nix
    # nix shell nixpkgs#wirelesstools --command iwconfig
    extraModprobeConfig = ''
      options iwlwifi power_save=0
      options iwlmvm power_scheme=1
    '';

    kernelParams = [
      # Fix s2idle: https://www.phoronix.com/news/More-s2idle-Rembrandt-Linux
      # https://github.com/NixOS/nixos-hardware/blob/master/lenovo/yoga/7/14ARH7/shared.nix#L25
      "acpi.prefer_microsoft_dsm_guid=1"
    ];

    # https://fedoraproject.org/wiki/Changes/IncreaseVmMaxMapCount
    # kernel.sysctl = {
    #   "vm.max_map_count" = 2147483642;
    # };

    # plymouth = {
    #   theme = "double";
    #   themePackages = [pkgs.adi1090x-plymouth-themes];
    # };

    # zswap
    kernel.sysfs.module.zswap.parameters = {
      # enabled = true;
      zpool = "zsmalloc";
      compressor = "zstd";
    };

    # binfmt.emulatedSystems = [
    #   "aarch64-linux"
    #   "riscv64-linux"
    # ];
  };

  # Swapfile
  # swapDevices = [
  #   {
  #     device = "/var/swapfile";
  #     size = 1024 * 16;
  #   }
  # ];

  zramSwap.enable = true;

  # ╭──────────────────────────────────────────────────────────╮
  # │ BOOTLOADER                                               │
  # ╰──────────────────────────────────────────────────────────╯
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

    # ---------------------------------------
    # Systemd-boot
    # ---------------------------------------
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

    # ---------------------------------------
    # Limine
    # ---------------------------------------
    # https://github.com/limine-bootloader/limine/blob/trunk/CONFIG.md
    limine = {
      enable = true;
      maxGenerations = 8;
      # secureBoot.enable = true;
      style.interface.branding = " ";
      style.wallpapers = [
        # pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath
        # pkgs.nixos-artwork.wallpapers.gnome-dark.gnomeFilePath
        # pkgs.nixos-artwork.wallpapers.stripes-logo.gnomeFilePath
      ];
      extraConfig = ''
        interface_help_hidden: yes
        remember_last_entry: yes
      '';
      extraEntries = ''
        /Windows
            protocol: efi
            path: boot(1):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };
    # ---------------------------------------
    # GRUB2
    # ---------------------------------------
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
