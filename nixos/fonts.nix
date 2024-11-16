{ pkgs, ... }:
{
  i18n.defaultLocale = "zh_CN.UTF-8";

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # source-han-sans-vf-otf
      # source-han-serif-vf-otf
      # source-han-sans
      # source-han-serif
      # sarasa-gothic
      # lxgw-wenkai
      source-code-pro
      # comic-relief
      # font-awesome
      emacs-all-the-icons-fonts
      hack-font
      fira-code
      mononoki
      lexend # improve reading fluency
      # recursive
      # ibm-plex
      jetbrains-mono
      # cascadia-code
      (nerdfonts.override {
        fonts = [
          # "FiraCode"
          # "JetBrainsMono"
          "NerdFontsSymbolsOnly"
        ];
      })
    ];

    fontconfig = {
      # antialias = true; # default true
      # hinting.enable = false; # default true
      # subpixel = {
      #   rgba = "none"; # default rgb
      #   lcdfilter = "none"; # default default
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
      };
    };
  };
}
