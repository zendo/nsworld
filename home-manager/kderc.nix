{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  # WIP!!!
  programs.plasma = {
    enable = true;
    files = {
      "kwalletrc"."Wallet"."First Use" = false;
      "dolphinrc"."General"."ShowFullPath" = true;
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "plasmarc"."Theme"."name" = "breeze-dark"; # TODO

      kxkbrc = {
        "Layout"."Use" = true;
        "Layout"."SwitchMode" = "Global";
        "Layout"."LayoutList" = "cn";
        "Layout"."Options" = "ctrl:swapcaps";
      };

      kwinrc = {
        "Desktops"."Rows" = 2;
        "Desktops"."Number" = 2;
        "Desktops"."Name_1" = "main";
        "Desktops"."Name_2" = "temp";

        "NightColor"."Active" = true;
        # "NightColor"."Mode" = "Location";

        Plugins = {
          wobblywindowsEnabled = true;
          # blurEnabled = false;
          # contrastEnabled = true;
          # kwin4_effect_squashEnabled = false;
          # magiclampEnabled = true;
          # zoomEnabled = false;
        };

        Windows = {

        };

        # TODO
        "org.kde.kdecoration2" = {
          ShowToolTips = false;
          ButtonsOnLeft = "M";
          ButtonsOnRight = "IAX";
        };
      };
    };

    shortcuts = {
      "emacs.desktops"."_launch" = "Meta+E";
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
