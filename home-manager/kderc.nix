{ inputs, ... }:
{
  imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  programs.kate = {
    enable = true;
    lsp.customServers = {
      nix = {
        command = [ "nil" ];
        highlightingModeRegex = "^Nix$";
        url = "https://github.com/oxalica/nil";
      };
    };
  };

  # rm .config/k* .config/plasma* .config/power*
  # rm .local/share/plasma-manager/last_run_* ; ~/.local/share/plasma-manager/run_all.sh
  programs.plasma = {
    enable = true;

    workspace = {
      # clickItemTo = "open";
      lookAndFeel = "org.kde.breezetwilight.desktop"; # breezedark, breezetwilight
      # cursor = {
      #   theme = "Bibata-Modern-Ice";
      #   size = 32;
      # };
      # iconTheme = "Papirus-Dark";
      # colorScheme = "Genshin";
      # wallpaperPictureOfTheDay = {
      #   provider = "bing";
      # };
      # wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
    };

    # fonts = {
    #   general = {
    #     family = "JetBrains Mono";
    #     pointSize = 12;
    #   };
    # };

    # 面板
    panels = [
      {
        location = "bottom";
        height = 44; # default value
        # floating = true;
        widgets = [
          "org.kde.plasma.panelspacer" # 面板间隙
          "org.kde.plasma.kickoff"
          "org.kde.plasma.marginsseparator" # 边距分隔符
          {
            iconTasks = {
              launchers = [
                "applications:kitty.desktop"
                "applications:org.kde.dolphin.desktop"
                # "applications:org.kde.kate.desktop"
                # "applications:emacs.desktop"
                "applications:firefox.desktop"
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
    ]; # panels end here.

    kwin = {
      titlebarButtons = {
        left = [ "more-window-actions" ];
        # right = [
        #   "minimize"
        #   "maximize"
        #   "close"
        # ];
      };
      virtualDesktops = {
        number = 4;
        rows = 2;
        names = [
          "壹"
          "贰"
          "叁"
          "肆"
        ];
      };
      # 窗口管理 - 桌面特效
      effects = {
        wobblyWindows.enable = true;
        cube.enable = true;
        desktopSwitching.animation = "slide";
      };
    }; # kwin end here.

    configFile = {
      # 搜索
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;

      # dolphin
      dolphinrc."General"."ShowFullPath" = true;

      # 密码库
      kwalletrc = {
        "Wallet"."Enabled" = false;
        "Wallet"."First Use" = false;
      };

      # 剪贴板
      klipperrc = {
        "General"."MaxClipItems" = 300;
      };

      # FIXME: https://github.com/pjones/plasma-manager/issues/47
      # kcminputrc = {
      #   "Libinput.1739.52804.MSFT0001:00 06CB:CE44 Touchpad"."NaturalScroll" = true;
      # };

      # 锁屏
      kscreenlockerrc = {
        "Daemon"."Timeout" = 8; # minutes
      };

      # 电源管理
      # powermanagementprofilesrc = {
      #   "AC.DPMSControl".idleTime = 780; # 13 min
      #   "AC.DimDisplay".idleTime = 480000; # 8 min
      #   "AC.HandleButtonEvents" = {
      #     lidAction = 32;
      #     triggerLidActionWhenExternalMonitorPresent = false;
      #   };
      #   "AC.SuspendSession" = {
      #     idleTime = null;
      #     suspendThenHibernate = null;
      #     suspendType = null;
      #   };
      #   "Battery.DPMSControl".idleTime = 600; # 10 min
      #   "Battery.DimDisplay".idleTime = 300000; # 5 min
      #   "Battery.HandleButtonEvents".triggerLidActionWhenExternalMonitorPresent = false;
      #   "Battery.SuspendSession" = {
      #     idleTime = null;
      #     suspendThenHibernate = null;
      #     suspendType = null;
      #   };
      #   "LowBattery.SuspendSession".suspendThenHibernate = false;
      # }; #### powermanagement end here.

      kwinrc = {
        # 夜间颜色 2700K~3000K
        NightColor = {
          "Active" = true;
          "Mode" = "Location";
          "LatitudeFixed" = 23.12;
          "LongitudeFixed" = 113.26;
          "NightTemperature" = 3300;
        };

        # 窗口管理 - 任务切换器
        TabBox = {
          LayoutName = "big_icons";
          # HighlightWindows = false;
        };

        # Windows = {

        # };
      }; # ### kwinrc end here.

      # 键盘 - 布局/高级
      kxkbrc = {
        "Layout"."Use" = true;
        "Layout"."ResetOldOptions" = true;
        "Layout"."SwitchMode" = "Global";
        "Layout"."LayoutList" = "cn";
        "Layout"."Options" = "ctrl:swapcaps";
      };
    }; # configFile end here.

    # 键盘 - 快捷键
    shortcuts = {
      "emacs.desktop"."_launch" = "Meta+E";
      "firefox.desktop"."_launch" = "Meta+W";
      "kitty.desktop"."_launch" = "Meta+Return";

      "org.kde.dolphin.desktop"."_launch" = "Meta+F";
      "org.kde.plasma.emojier.desktop"."_launch" = "Meta+.";
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
      }; # kwin end here.
    }; # shortcuts end here.
  }; # programs.plasma end here.
}
