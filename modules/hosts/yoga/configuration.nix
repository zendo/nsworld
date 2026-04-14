{ inputs, ... }:
{
  flake.nixosConfigurations.yoga = inputs.nixpkgs.lib.nixosSystem {
    modules =
      with inputs.self.modules.nixos;
      [
        host-yoga

        # [ profiles ]
        hmModule
        default-imports
        laptop
        steam

        # [ virt ]
        docker
        # incus
        # nix-ld
        qemu

        # [ desktop ]
        graphical
        gnome
        # kde
        # cosmic
        # niri
        # sway
        # hyprland
      ]
      ++ [
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        # inputs.lanzaboote.nixosModules.lanzaboote
      ];
  };

  flake.modules.nixos.host-yoga =
    { pkgs, config, ... }:
    {
      myVars.user = "iab";
      networking.hostName = "yoga";

      environment.systemPackages = with pkgs; [
        # inputs.nixpkgs-pr.legacyPackages.${stdenv.hostPlatform.system}.apps
        inputs.nix-alien.packages.${stdenv.hostPlatform.system}.nix-alien
      ];

      # nix.package = inputs.determinate.packages.${pkgs.stdenv.hostPlatform.system}.default;

      # ╭─────────────────────────────────────────────────────╮
      # │ HOME-MANAGER                                        │
      # ╰─────────────────────────────────────────────────────╯
      home-manager.users.${config.myVars.user} = {
        imports = [
          inputs.self.modules.homeManager.default-imports
        ];

        dconf.settings = {
          "org/gnome/settings-daemon/plugins/power" = {
            # 修复恢复时蓝牙鼠标连接缓慢问题
            # 电源 - 节电 - 自动挂起（插入电源时关闭）
            sleep-inactive-ac-type = "nothing";
          };
        };
      };

      # ╭─────────────────────────────────────────────────────╮
      # │ HARDWARE                                            │
      # ╰─────────────────────────────────────────────────────╯
      boot = {
        supportedFilesystems = [ "ntfs" ];

        # latest / zen / lqx / xanmod_latest
        kernelPackages = pkgs.linuxPackages_latest;

        # for Lenovo Yoga/Xiaoxin
        kernelParams = [
          # Fix s2idle: https://www.phoronix.com/news/More-s2idle-Rembrandt-Linux
          # https://github.com/NixOS/nixos-hardware/blob/master/lenovo/yoga/7/14ARH7/shared.nix#L25
          "acpi.prefer_microsoft_dsm_guid=1"
          # Fix touhpad multitouch somtimes unavailable
          "psmouse.synaptics_intertouch=1"
        ];

        # zswap: grep -r . /sys/module/zswap/parameters/
        kernel.sysfs.module.zswap.parameters = {
          enabled = true;
          compressor = "zstd";
          shrinker_enabled = true;
        };

        # binfmt.emulatedSystems = [
        #   "aarch64-linux"
        #   "riscv64-linux"
        # ];
      };

      # zramSwap.enable = true;

      # swapfile
      # swapDevices = [
      #   {
      #     device = "/var/swapfile";
      #     size = 1024 * 16;
      #   }
      # ];

      # ╭─────────────────────────────────────────────────────╮
      # │ BOOTLOADER                                          │
      # ╰─────────────────────────────────────────────────────╯
      /*
        Disable "Secure Boot" and reset to “Setup Mode”
        sudo -i
        sbctl create-keys
        sbctl enroll-keys -m -f
      */
      # boot.lanzaboote = {
      #   enable = true;
      #   configurationLimit = 3;
      #   pkiBundle = "/var/lib/secureboot";
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
        # https://codeberg.org/Limine/Limine/src/branch/trunk/CONFIG.md
        limine = {
          enable = true;
          maxGenerations = 8;
          # secureBoot.enable = true;
          style.interface = {
            branding = " ";
            helpHidden = true;
          };
          style.wallpapers = [
            # pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath
            # pkgs.nixos-artwork.wallpapers.gnome-dark.gnomeFilePath
            # pkgs.nixos-artwork.wallpapers.stripes-logo.gnomeFilePath
          ];
          extraConfig = ''
            remember_last_entry: yes
            # interface_help_hidden: yes
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
    };
}
