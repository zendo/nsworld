{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  # rm ~/.config/k*
  programs.plasma = {
    enable = true;
    files = {
      "kwalletrc"."Wallet"."First Use" = false;
      "dolphinrc"."General"."ShowFullPath" = true;
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "plasmarc"."Theme"."name" = "breeze-dark";

      kdeglobals = {
        "KDE"."SingleClick" = false;
        # "Icons"."Theme" = "Newaita";
        # "General"."ColorScheme" = "Genshin";
      };

      kxkbrc = {
        "Layout"."Use" = true;
        "Layout"."ResetOldOptions" = true;
        "Layout"."SwitchMode" = "Global";
        "Layout"."LayoutList" = "cn";
        "Layout"."Options" = "ctrl:swapcaps";
      };

      klipperrc = {
        "General"."MaxClipItems" = 300;
        "General"."SyncClipboards" = true;
      };

      # TODO
      kcminputrc = {
        "Libinput.1739.52804.MSFT0001:00 06CB:CE44 Touchpad"."NaturalScroll" = true;
        "Libinput.1739.52804.MSFT0001:00 06CB:CE44 Touchpad"."TapToClick" = true;
      };

      kscreenlockerrc = {
        "Daemon"."Timeout" = 8;
      };

      # powermanagementprofilesrc = {
      # };

      kwinrc = {
        "Desktops"."Rows" = 2;
        "Desktops"."Number" = 4;
        "Desktops"."Name_1" = "one";
        "Desktops"."Name_2" = "two";
        "Desktops"."Name_3" = "three";
        "Desktops"."Name_4" = "four";

        "NightColor"."Active" = true;
        # "NightColor"."Mode" = "Location";
        "NightColor"."NightTemperature" = 3800;

        Plugins = {
          wobblywindowsEnabled = true;
          # blurEnabled = false;
          # contrastEnabled = true;
          # kwin4_effect_squashEnabled = false;
          # magiclampEnabled = true;
          # zoomEnabled = false;
        };

        TabBox = {
          LayoutName = "big_icons";
          # HighlightWindows = false;
        };


        # Windows = {

        # };

        # https://github.com/pjones/plasma-manager/issues/8
        # "org.kde.kdecoration2" = {
        #   ButtonsOnLeft = "M";
        #   ButtonsOnRight = "IAX";
        #   ShowToolTips = false;
        # };
      };
    };

    shortcuts = {
      "emacs.desktop"."_launch" = "Meta+E";
      "firefox.desktop"."_launch" = "Meta+W";
      "kitty.desktop"."_launch" = "Meta+Return";
      "org.kde.dolphin.desktop"."_launch" = "Meta+F";
      "org.kde.plasma.emojier.desktop"."_launch" = "Meta+.";
      "org.kde.krunner.desktop"."_launch" = ["Search" "Alt+F2" "Meta+X"];

      kwin = {
        "Window Close" = ["Alt+F4" "Meta+Q"];

        "Window to Desktop 1" = "Alt+1";
        "Window to Desktop 2" = "Alt+2";
        "Window to Desktop 3" = "Alt+3";
        "Window to Desktop 4" = "Alt+4";

        "Switch to Desktop 1" = ["Meta+1" "Ctrl+F1"];
        "Switch to Desktop 2" = ["Meta+2" "Ctrl+F2"];
        "Switch to Desktop 3" = ["Meta+3" "Ctrl+F3"];
        "Switch to Desktop 4" = ["Meta+4" "Ctrl+F4"];
      };
    };
  };
}
