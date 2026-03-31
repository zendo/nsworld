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
          maple-mono.NL-NF-CN-unhinted
          # https://zhuanlan.zhihu.com/p/627059922
          # sarasa-gothic
          # lxgw-wenkai
        ];

        fonts.fontconfig = {
          # antialias = true; # default value: true
          # hinting = {
          #   enable = false; # default value: true
          #   autohint = false; # default value: false
          #   style = "slight"; # default value: slight
          # };
          # subpixel = {
          #   rgba = "none"; # default value: none
          #   lcdfilter = "default"; # default value: default
          # };
          defaultFonts = {
            emoji = [ "Noto Color Emoji" ];
            monospace = [
              "Noto Sans Mono CJK SC"
              "Sarasa Mono SC"
              "DejaVu Sans Mono"
            ];
            sansSerif = [
              "Noto Sans CJK SC"
              "Source Han Sans SC"
              "DejaVu Sans"
            ];
            serif = [
              "Noto Serif CJK SC"
              "Source Han Serif SC"
              "DejaVu Serif"
            ];
          }; # end of defaultFonts
        }; # end of fontconfig
      }) # end of zh_CN.UTF-8

    ];
}
