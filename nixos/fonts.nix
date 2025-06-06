{ pkgs, ... }:
{
  i18n.defaultLocale = "zh_CN.UTF-8";

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # sarasa-gothic
      # lxgw-wenkai
      # No-Ligature, Nerd-Font, Unhinted for HiDPI
      maple-mono.NL-NF-CN-unhinted
      maple-mono.variable
      mononoki
      hack-font
      fira-code
      jetbrains-mono
      source-code-pro
      # geist-font
      # ibm-plex
      # cascadia-code # Microsoft
      # recursive
      # comic-relief
      # alegreya
      lexend # improve reading fluency
      nerd-fonts.symbols-only
      fast-font
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
