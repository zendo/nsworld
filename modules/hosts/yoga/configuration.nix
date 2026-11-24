{ inputs, config, ... }:
let
  userName = "iab";
  hostName = "yoga";
  fm = config.flake.modules;
in
{
  flake.nixosConfigurations.yoga = inputs.nixpkgs.lib.nixosSystem {
    modules =
      with fm.nixos;
      [
        host-yoga
        hjemModule
        # hm-imports

        # [ profiles ]
        gpu-amd
        laptop
        workstation
        # steam

        # [ programs ]
        ai
        dev

        # [ shell ]
        # fish
        zsh

        # [ virt ]
        # docker
        kiri
        incus
        # nix-ld
        qemu
        # oci-papyra

        # [ desktop ]
        graphical
        # gnome
        kde
        # cosmic
        # niri
        # sway
        # hyprland
        # umbriel
      ]
      ++ [
        # inputs.omniflake.flakes.lanzaboote.nixosModules.lanzaboote
      ];
  };

  flake.modules.nixos.host-yoga =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      myVars.user = userName;
      networking.hostName = hostName;
      users.defaultUserShell = pkgs.zsh;
      # `mkpasswd`
      users.users.${userName}.initialHashedPassword =
        "$y$j9T$aNhZV153pAbvGMeFqjGmn.$iH18jxovF5Huof8U4NNPK/EVWHH75o5x8lRzq8IHZO3";
      # No passwd on my main machine
      security.sudo.wheelNeedsPassword = false;
      security.sudo-rs.wheelNeedsPassword = false;
      security.run0.wheelNeedsPassword = false;

      # [ services ]
      # systemd.user.services.neiro.enable = true;

      virtualisation.kiri = {
        enable = true;
        users = [ "${userName}" ];
      };

      # [ selfhosted ]
      # services.homepage-dashboard.enable = true;
      # services.miniflux.enable = true;
      # services.suwayomi-server.enable = true;
      services.goshs = {
        # enable = true;
        settings.directory = "/home/${userName}/Downloads";
        settings.uploadFolder = "/home/${userName}/Downloads";
      };
      # services.beszel = {
      #   agent.enable = true;
      #   agent.environment = {
      #     KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+TKipwAtOLgUUrHIXNb5AYxDNc1E63ELFT4XNOZlXF";
      #   };
      # };

      # 用户级 syncthing:登录后才跑,配置在 ~/.config/syncthing,GUI 127.0.0.1:8384
      # (user 级实例不吃 services.syncthing.dataDir/guiAddress 这些系统级选项)
      # services.syncthing = {
      #   enable = true;
      #   systemService = false;
      #   # 只放行同步端口(22000 TCP/UDP + 21027 UDP),方便 LAN 直连和发现
      #   openDefaultPorts = true;
      # };
      # systemd.user.services.syncthing.wantedBy = [ "default.target" ];

      # Persistent Cache
      system.extraDependencies = [
        inputs.self.formatter.${pkgs.stdenv.hostPlatform.system}
        # inputs.self.nixosConfigurations.svp.config.system.build.toplevel
      ];

      environment.systemPackages = with pkgs; [
        inputs.omniflake.flakes.nix-tree-rs.packages.x86_64-linux.default
        # inputs.omniflake.flakes.helium-flake.packages.x86_64-linux.helium-widevine
        # inputs.omniflake.flakes.nix-packages-ccicnce113424.packages.x86_64-linux.open-orpheus
        # inputs.omniflake.flakes."github:xddxdd/nur-packages".packages.x86_64-linux.baidunetdisk
        # [ deploy ]
        disko
        nixos-anywhere
        colmena
        deploy-rs
        # [ nix ]
        nix-init
        nix-update
        # Qt 文字渲染 hook，见下面 environment.variables
        fontreal
        # inputs.omniflake.pinned.nix-alien.packages.${stdenv.hostPlatform.system}.nix-alien
        # inputs.nixpkgs-pr.legacyPackages.${stdenv.hostPlatform.system}.apps
      ];

      # fontreal 是 Qt 通用插件（generic plugin），会话里只要有 Qt6 程序就会加载。
      # Qt 在 QT_PLUGIN_PATH 的每一项下面找子目录 generic/，所以这里给的是
      # plugins 目录，不是 plugins/generic（给错一层就会静默地什么都不加载）。
      # 追加搜索路径，不会顶掉 Qt 默认的插件目录；fcitx5 已用列表形式定义它，
      # 这里也必须是列表才能合并。
      environment.variables = {
        QT_PLUGIN_PATH = [ "${pkgs.fontreal}/lib/fontreal/qt6/plugins" ];
        QT_QPA_GENERIC_PLUGINS = "fontreal-cached-probe,fontreal-quick-default-probe";
        FONTREAL_QUAL_TONE = "1";
      };

      # nix.package = pkgs.lixPackageSets.stable.lix;
      # nix.package = inputs.determinate.packages.${pkgs.stdenv.hostPlatform.system}.default;

      # Fix on this machine
      # programs.dconf.profiles.user.databases = [
      #   {
      #     settings = {
      #       "org/gnome/settings-daemon/plugins/power" = {
      #         # 修复恢复时蓝牙鼠标连接缓慢问题
      #         # 电源 - 节电 - 自动挂起（插入电源时关闭）
      #         sleep-inactive-ac-type = "nothing";
      #       };
      #     };
      #   }
      # ];

      # ╭─────────────────────────────────────────────────────╮
      # │ HARDWARE                                            │
      # ╰─────────────────────────────────────────────────────╯
      # sudo modprobe -r hid-multitouch && sudo modprobe hid-multitouch
      boot = {
        supportedFilesystems = [ "ntfs" ];

        kernel.sysctl."vm.swappiness" = 100;

        # zswap + swapfile
        # grep -r . /sys/module/zswap/parameters/
        # zswap.enable = true;

        # binfmt.emulatedSystems = [
        #   "aarch64-linux"
        #   "riscv64-linux"
        # ];
      };

      # 磁盘 swap 兜底。zram 优先级更高，正常使用下这里永远不会被碰；
      # 只有 zram 压满后才溢出到这里，避免直接 OOM 杀进程。
      swapDevices = [
        {
          device = "/var/swapfile";
          size = 1024 * 4;
        }
      ];

      # zram 是主力 swap，swapfile 只兜底。
      # 默认 50% 在这台 14 GiB 机器上等于 7.2 GiB 的压缩块设备，真被填满会先挤掉
      # page cache（workingset_refault_file 上涨，切窗口变慢）；zstd 对匿名页约 2-3x，
      # 25%(≈3.6 GiB) 能装下 7-10 GiB 的换出页，够用且把上限压到 1/4 RAM。
      zramSwap = {
        enable = true;
        memoryPercent = 25;
      };

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
        # https://github.com/Limine-Bootloader/Limine/blob/v12.x/CONFIG.md
        limine = {
          enable = true;
          maxGenerations = 8;
          # secureBoot.enable = true;
          style = {
            interface = {
              branding = " ";
              helpHidden = true;
            };
            wallpapers = [
              # pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath
              # pkgs.nixos-artwork.wallpapers.gnome-dark.gnomeFilePath
              # pkgs.nixos-artwork.wallpapers.stripes-logo.gnomeFilePath
            ];
          };
          extraConfig = ''
            remember_last_entry: yes
          '';
          extraEntries = ''
            /+Other systems
              //Windows
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
