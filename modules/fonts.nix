{
  config,
  pkgs,
  ...
}: {
  i18n.defaultLocale = "zh_CN.UTF-8";

  fonts = {
    # create /run/current-system/sw/share/X11/fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # sarasa-gothic
      # lxgw-wenkai
      # source-han-sans
      # source-han-serif
      source-code-pro
      # comic-relief
      emacs-all-the-icons-fonts
      hack-font
      fira-code
      jetbrains-mono
    ];

    fontconfig = {
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
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
