{
  config,
  pkgs,
  ...
}: {
  i18n.defaultLocale = "zh_CN.UTF-8";

  fonts = {
    # /run/current-system/sw/share/X11/fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      sarasa-gothic
      lxgw-wenkai
      source-han-sans
      source-han-serif
      source-code-pro
      comic-relief
      emacs-all-the-icons-fonts
      hack-font
      fira-code
      jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        monospace = ["Sarasa Mono SC" "DejaVu Sans Mono"];
        emoji = ["Noto Color Emoji"];
        sansSerif = [
          "Source Han Sans SC"
          "Noto Sans CJK SC"
        ];
        serif = [
          "Source Han Serif SC"
          "Noto Serif CJK SC"
        ];
      };
    };
  };
}
