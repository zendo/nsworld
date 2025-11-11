{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.mods.fcitx;
in
{
  options.mods.fcitx = {
    enable = lib.mkEnableOption ''
      my fcitx5 customize.
    '';
  };

  config = lib.mkIf cfg.enable {
    # fix svg theme
    programs.gdk-pixbuf.modulePackages = lib.mkDefault [ pkgs.librsvg ];

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;

      fcitx5.addons = with pkgs; [
        fcitx5-fluent
        fcitx5-mellow-themes
        # 命令行手动部署
        # nix shell nixpkgs#librime --command rime_deployer --build ~/.local/share/fcitx5/rime /run/current-system/sw/share/rime-data ~/.local/share/fcitx5/rime/build
        (fcitx5-rime.override {
          rimeDataPkgs = [
            # 换个输入法方案需要重启再部署，不然环境不干净
            # /run/current-system/sw/share/rime-data/
            pkgs.rime-ice
            # pkgs.rime-wanxiang
          ];
        })
      ];

      fcitx5.settings = {
        inputMethod = {
          "GroupOrder" = {
            "0" = "default";
          };
          "Groups/0" = {
            "Name" = "default";
            "DefaultIM" = "rime";
            "Default Layout" = "us";
          };
          "Groups/0/Items/0" = {
            "Name" = "rime";
          };
          "Groups/0/Items/1" = {
            "Name" = "keyboard-us";
          };
        };
        globalOptions = {
          # 切换启用/禁用输入法
          "Hotkey/TriggerKeys" = {
            "0" = "";
            # "0" = "Control+space";
          };
          # 临时在当前和第一个输入法之间切换
          "Hotkey/AltTriggerKeys" = {
            "0" = "";
          };
        };
        addons = {
          classicui.globalSection = {
            Font = "Noto Sans CJK SC 12";
            # MenuFont = "Sans Serif 12";
            # TrayFont = "Sans Serif 12";
            Theme = "FluentDark-solid";
            # DarkTheme = "mellow-youlan-dark"; # FluentDark-solid/mellow-youlan-dark
            # UseDarkTheme = true; # 跟随系统浅色/深色设置
          };
          clipboard = {
            globalSection = {
              "TriggerKey" = "";
            };
            # sections.TriggerKey = {
            #   "0" = "Control+Alt+semicolon";
            # };
          };
          notifications = {
            globalSection = { };
            sections.HiddenNotifications = {
              "0" = "fcitx-rime-deploy";
            };
          };
        }; # end of addons
      }; # end of fcitx5.settings
    }; # end of i18n.inputMethod
  }; # end of config
}
