{ inputs, ... }:
{
  flake.modules.homeManager.plasma-manager = {
    imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

    # rm .config/k* .config/plasma* .config/power*
    # rm .local/share/plasma-manager/last_run_* ; ~/.local/share/plasma-manager/run_all.sh
    programs.plasma = {
      enable = true;

      panels = [
        {
          location = "bottom";
          height = 44; # default value
          # floating = true;
          ## .config/plasma-org.kde.plasma.desktop-appletsrc
          widgets = [
            "plasmusic-toolbar"
            "org.kde.plasma.panelspacer" # 面板间隙
            "org.kde.plasma.kickoff"
            "org.kde.plasma.marginsseparator" # 边距分隔符
            {
              iconTasks = {
                launchers = [
                  # "applications:kitty.desktop"
                  "applications:com.mitchellh.ghostty.desktop"
                  "preferred://filemanager"
                  # "applications:org.kde.dolphin.desktop"
                  # "applications:emacs.desktop"
                  # "applications:code.desktop"
                  "preferred://browser"
                  # "applications:firefox.desktop"
                  "applications:org.telegram.desktop.desktop"
                ];
              };
            }
            "org.kde.plasma.panelspacer" # 面板间隙
            "org.kde.plasma.marginsseparator" # 边距分隔符
            {
              systemTray.items = {
                # We explicitly show bluetooth and battery
                shown = [
                  "org.kde.plasma.volume"
                  "org.kde.plasma.networkmanagement"
                ];
                # And explicitly hide networkmanagement and volume
                hidden = [
                  "org.kde.plasma.battery"
                  "org.kde.plasma.bluetooth"
                ];
              };
            }
            {
              digitalClock = {
                calendar.firstDayOfWeek = "monday";
                time.format = "24h";
              };
            }
            "org.kde.plasma.showdesktop"
            "org.kde.plasma.pager" # 虚拟桌面切换器
          ];
        }
        # {
        #   location = "top";
        #   height = 26;
        #   widgets = [
        #     "org.kde.plasma.appmenu"
        #   ];
        # }
      ];

      ###############################################
      ## kwin .config/kwinrc
      ###############################################
      kwin = {
        virtualDesktops = {
          number = 4;
          rows = 2;
        };
        # 窗口管理 - 桌面特效
        effects = {
          # 窗口惯性晃动
          wobblyWindows.enable = true;
        };
        # 夜间颜色 2700K~3000K
        nightLight = {
          enable = true;
          # mode = "location";
          temperature = {
            night = 3200;
          };
        };
      };

      ###############################################
      ## inputs
      ###############################################
      input.mice = [
        # cat /proc/bus/input/devices
        {
          # yoga laptop touchpad
          name = "MSFT0001:00 06CB:CE44 Touchpad";
          productId = "ce44";
          vendorId = "06cb";
          naturalScroll = true;
          enable = true;
        }
      ];

      ###############################################
      ## configFile
      ###############################################
      configFile = {
        # 搜索
        baloofilerc."Basic Settings"."Indexing-Enabled" = false;

        # dolphin
        dolphinrc."General"."ShowFullPath" = true;

        # 密码库
        # kwalletrc = {
        #   "Wallet"."Enabled" = false;
        #   "Wallet"."First Use" = false;
        # };

        # 剪贴板
        klipperrc = {
          "General"."MaxClipItems" = 300;
        };

        kwinrc = {
          # 窗口管理 - 任务切换器
          # TabBox = {
          #   LayoutName = "big_icons";
          #   # HighlightWindows = false;
          # };

          # Windows = {
          # };

          # fcitx5-wayland-launcher.desktop or org.fcitx.Fcitx5.desktop
          Wayland.InputMethod = "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
        };
      };

      ###############################################
      ## 键盘 - 快捷键
      ###############################################
      shortcuts = {
        "emacs.desktop"."_launch" = "Meta+E";
        "firefox.desktop"."_launch" = "Meta+W";
        "com.mitchellh.ghostty.desktop"."_launch" = "Meta+Return";

        "org.kde.dolphin.desktop"."_launch" = "Meta+F";
        "org.kde.krunner.desktop"."_launch" = [
          "Search"
          "Alt+F2"
          "Meta+X"
        ];

        ksmserver = {
          "Log Out" = [
            "Meta+Esc"
            "Ctrl+Alt+Del"
          ];
          # "Lock Session" = [
          #   "Screensaver"
          #   "Meta+Ctrl+Alt+L"
          # ];
        };

        kwin = {
          "Window Close" = [
            "Alt+F4"
            "Meta+Q"
          ];

          "Window to Desktop 1" = "Alt+1";
          "Window to Desktop 2" = "Alt+2";
          "Window to Desktop 3" = "Alt+3";
          "Window to Desktop 4" = "Alt+4";

          "Switch to Desktop 1" = [
            "Meta+1"
            "Ctrl+F1"
          ];
          "Switch to Desktop 2" = [
            "Meta+2"
            "Ctrl+F2"
          ];
          "Switch to Desktop 3" = [
            "Meta+3"
            "Ctrl+F3"
          ];
          "Switch to Desktop 4" = [
            "Meta+4"
            "Ctrl+F4"
          ];
        }; # kwin
      }; # shortcuts
    }; # programs.plasma

    programs.kate = {
      enable = true;
      lsp.customServers = {
        nix = {
          command = [ "nixd" ];
          url = "https://github.com/nix-community/nixd";
          highlightingModeRegex = "^Nix$";
        };
      };
    };
  };
}
