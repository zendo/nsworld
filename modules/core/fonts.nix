{
  flake.modules.nixos.fonts =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    lib.mkMerge [
      {
        fonts.packages = with pkgs; [
          # [ Essential ]
          adwaita-fonts
          noto-fonts-color-emoji
          nerd-fonts.symbols-only

          # [ Programming ]
          maple-mono.variable
          jetbrains-mono
          source-code-pro
          hack-font
          fira-code
          mononoki
          # ibm-plex
          # geist-font
          # recursive
          # cascadia-code # Microsoft

          # [ MISC ]
          # comic-relief
          # alegreya # for comfortable reading
          lexend # improve reading fluency
        ];
      }

      # :chinese
      (lib.mkIf (config.i18n.defaultLocale == "zh_CN.UTF-8") {
        fonts.packages = with pkgs; [
          # noto-fonts-cjk-sans-static
          # noto-fonts-cjk-serif-static
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          # 用「有 hint」版本，配合下面的 hinting = slight；
          # 原 -unhinted 无 hint 指令，开启 hinting 也无效果，小字号会发虚
          maple-mono.NL-NF-CN
          # https://zhuanlan.zhihu.com/p/627059922
          # sarasa-gothic
          # lxgw-wenkai
        ];

        fonts.fontconfig = {
          # ── 渲染参数 ─────────────────────────────────────────────
          # ⚠️ 改这里必须先确认硬件与缩放。本机：yoga，2880x1800 14" ≈ 242 PPI，
          # GNOME scale=2 → 逻辑 ≈ 121 PPI，且 monitors.xml 是整数 2×（未用
          # fractional scaling），面板为 IPS（subpixel 为标 RGB stripe）。
          #
          # ⚠️ 必须与 GTK 侧 dconf 同步，否则会出现
          # 「GTK 有 color fringing、终端没有」的观感跳变：
          #   gsettings set org.gnome.desktop.interface font-antialiasing rgba
          #   gsettings set org.gnome.desktop.interface font-rgba-order rgb
          #
          # 若以后改用 fractional scaling（1.25/1.333/1.5）：mutter 是整数倍
          # 渲染再下采样，subpixel 结构被破坏、rgb 会变成明显的错误 color
          # fringing ⇒ 应改回 subpixel.rgba = "none"（同时改 dconf）。
          #
          # antialias = true; # default: true
          # hinting = {
          #   enable = true; # default: true
          #   autohint = false; # default: false（CJK 字体开 autohint 通常更糊）
          #   style = "slight"; # none|slight|medium|full，default: slight；
          #                     # HiDPI 下别用 medium/full，笔画粗细会不均
          # };
          # subpixel = {
          #   rgba = "rgb"; # default: none
          #   # 只在 rgba != "none" 时生效：none|default|light|legacy
          #   # default 最锐；轻一点、color fringing 更弱可用 light
          #   lcdfilter = "default"; # default: default
          # };

          defaultFonts = {
            # emoji = [ "Noto Color Emoji" ]; # 默认值

            sansSerif = [
              "Noto Sans CJK SC"
              "DejaVu Sans"
            ];

            monospace = [
              "Noto Sans Mono CJK SC"
              "DejaVu Sans Mono"
              "Symbols Nerd Font Mono"
            ];

            serif = [
              "Noto Serif CJK SC"
              "DejaVu Serif"
            ];
          };
        };
      })

    ];
}
