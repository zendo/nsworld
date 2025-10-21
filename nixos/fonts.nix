{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf (config.i18n.defaultLocale == "zh_CN.UTF-8") {
    fonts = {
      packages = with pkgs; [
        ######## Necessary #########
        adwaita-fonts
        noto-fonts-color-emoji
        nerd-fonts.symbols-only
        ####### Chinese #########
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        # sarasa-gothic
        # lxgw-wenkai
        ###### Programming ########
        maple-mono.variable
        maple-mono.NL-NF-CN-unhinted
        jetbrains-mono
        source-code-pro
        hack-font
        fira-code
        mononoki
        # ibm-plex
        # geist-font
        # recursive
        # cascadia-code # Microsoft
        ###### MISC ########
        # comic-relief
        # alegreya # for comfortable reading
        lexend # improve reading fluency
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
        }; # defaultFonts
      }; # fontconfig
    }; # fonts
  }; # config
}
