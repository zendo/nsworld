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
          # GNOME scale=2 → 逻辑 ≈ 121 PPI，故取「灰度 AA + slight」：
          #   - 242 PPI 下次像素渲染没有清晰度收益，只剩边缘彩边；
          #   - OLED 子像素多非标准 RGB stripe，Wayland 又拿不到子像素几何；
          #   - 若开分数缩放（1.25/1.333/1.5），mutter 是整数倍渲染再下采样，
          #     子像素结构被破坏，rgb 会变成明显错误彩边 ⇒ 保持 none。
          #
          # 想切次像素时，必须同时改 GTK 侧的 dconf，否则会出现
          # 「GTK 有彩边、终端没有」的不一致：
          #   gsettings set org.gnome.desktop.interface font-antialiasing rgba
          #   gsettings set org.gnome.desktop.interface font-rgba-order rgb
          #
          # antialias = true; # default: true
          # hinting = {
          #   enable = true; # default: true
          #   autohint = false; # default: false（CJK 字体开 autohint 通常更糊）
          #   style = "slight"; # none|slight|medium|full，default: slight；
          #                     # HiDPI 下别用 medium/full，笔画粗细会不均
          # };
          # subpixel = {
          #   rgba = "none"; # default: none，即灰度抗锯齿（推荐值，见上）
          #   # lcdfilter 只在 rgba != "none" 时才有意义，灰度下设置是空转
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
