# plasma-manager 的 hjem 版本，迁移自 modules/desktop/plasma-manager.nix。
#
# 目前**未启用**：需要在某台 host 的 hjem user 里 import 才会生效，例如
#   hjem.users.<user>.imports = [ config.flake.modules.hjem.kde ];
# （hjemModule 里已设 clobberFiles = true，会覆盖已存在的同名文件）
#
# 只覆盖「纯 INI / 纯 JSON」的部分。以下两块仍留给 plasma-manager：
#   - panels：plasma-org.kde.plasma.desktop-appletsrc 里的 Containment ID 是
#     plasmashell 自增的，手写不可移植；
#   - shortcuts：kglobalshortcutsrc 是「当前,默认,描述」三段格式 + _k_friendly_name
#     + \t / Meta+\, 之类的转义，手写易错。
{
  flake.modules.hjem.kde =
    { lib, ... }:
    let
      # KConfig 允许 section 名里带 []（如 kcminputrc 的
      # [Libinput][1739][52804][设备名]），而 toINI 默认会转义它们，故自定义。
      toKConfig = lib.generators.toINI { mkSectionName = name: name; };
    in
    {
      xdg.config.files = {
        # 文件索引（baloo）
        "baloofilerc" = {
          generator = toKConfig;
          value."Basic Settings"."Indexing-Enabled" = false;
        };

        # 文件管理器
        "dolphinrc" = {
          generator = toKConfig;
          value."General"."ShowFullPath" = true;
        };

        # 剪贴板
        "klipperrc" = {
          generator = toKConfig;
          value."General"."MaxClipItems" = 300;
        };

        # 虚拟桌面 / 桌面特效 / 夜间颜色 / Wayland 输入法
        # 注意：kwinrc 里 [Tiling]、[Xwayland] 等是运行期状态，不在此声明。
        "kwinrc" = {
          generator = toKConfig;
          value = {
            Desktops = {
              Number = 4;
              Rows = 2;
            };
            NightColor = {
              Active = true;
              NightTemperature = 3200;
            };
            Plugins.wobblywindowsEnabled = true;
            Wayland.InputMethod = "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
          };
        };

        # 触摸板：段名就是 [Libinput][vendor][product][设备名]
        # cat /proc/bus/input/devices 可查 vendor/product
        "kcminputrc" = {
          generator = toKConfig;
          value = {
            "Libinput][1739][52804][MSFT0001:00 06CB:CE44 Touchpad" = {
              Enabled = true;
              NaturalScroll = true;
            };
          };
        };

        # kate：自定义 LSP server（kate 读这个 JSON）
        "kate/lspclient/settings.json" = {
          generator = lib.generators.toJSON { };
          value.servers.nix = {
            command = [ "nixd" ];
            url = "https://github.com/nix-community/nixd";
            highlightingModeRegex = "^Nix$";
          };
        };
      };
    };
}
