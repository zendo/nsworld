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
    enable = lib.mkEnableOption "fcitx5 customize.";
    withPinyin = lib.mkEnableOption "pinyin customize.";
    withRime = lib.mkEnableOption "rime customize.";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.withPinyin || cfg.withRime;
        message = "Options `mods.fcitx` requires at least one input schema to be enabled!";
      }
      {
        assertion = cfg.withPinyin -> !cfg.withRime;
        message = "You can't use `mods.fcitx.withPinyin` and `mods.fcitx.withRime` at the same time!";
      }
    ];

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;

      fcitx5.addons =
        with pkgs;
        [
          fcitx5-fluent
          fcitx5-mellow-themes
        ]
        ++ lib.optionals cfg.withPinyin [
          qt6Packages.fcitx5-chinese-addons
          fcitx5-pinyin-zhwiki
        ]
        ++ lib.optionals cfg.withRime [
          # 命令行手动部署
          # nix shell nixpkgs#librime --command rime_deployer --build \
          # ~/.local/share/fcitx5/rime /run/current-system/sw/share/rime-data ~/.local/share/fcitx5/rime/build
          (fcitx5-rime.override {
            rimeDataPkgs = [
              # 换个输入法方案需要重启再部署，不然环境不干净
              # /run/current-system/sw/share/rime-data/
              pkgs.rime-ice
              # pkgs.rime-wanxiang
            ];
          })
        ];

      fcitx5.settings = lib.mkMerge [
        {
          addons = {
            classicui.globalSection = {
              Font = "Noto Sans CJK SC 12";
              # MenuFont = "Sans Serif 12";
              # TrayFont = "Sans Serif 12";
              # FluentDark-solid / mellow-youlan-dark / winter
              Theme = "mellow-youlan-dark";
              # DarkTheme = "mellow-youlan-dark";
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
                "1" = "wayland-diagnose-gnome";
              };
            };
          };
        }
        (lib.mkIf cfg.withPinyin {
          inputMethod = {
            "GroupOrder" = {
              "0" = "default";
            };
            "Groups/0" = {
              "Name" = "default";
              "DefaultIM" = "keyboard-us";
              "Default Layout" = "us";
            };
            "Groups/0/Items/0" = {
              "Name" = "keyboard-us";
            };
            "Groups/0/Items/1" = {
              "Name" = "pinyin";
            };
          };
          globalOptions = {
            # 切换启用/禁用输入法
            "Hotkey/TriggerKeys" = {
              "0" = "Shift+Shift_L";
              "1" = "Shift+Shift_R";
              # "0" = "Control+space";
            };
          };
          addons = {
            pinyin = {
              globalSection = {
                "SymbolsEnabled" = "False";
                "CloudPinyinEnabled" = "False";
              };
            };
          };
        })
        (lib.mkIf cfg.withRime {
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
        })
      ]; # end of fcitx5.settings
    }; # end of i18n.inputMethod
  }; # end of config
}
