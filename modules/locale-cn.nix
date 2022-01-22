{ config, pkgs, ... }:

{
  fonts = {
    # /run/current-system/sw/share/X11/fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      source-han-sans
      source-code-pro
      sarasa-gothic
      emacs-all-the-icons-fonts
      hack-font
      fira-code
      jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Sarasa Mono SC" "DejaVu Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans CJK SC" ];
        serif = [ "Noto Serif CJK SC" ];
      };
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-chinese-addons
    ];

    # enabled = "ibus";
    # ibus.engines = with pkgs.ibus-engines; [
    #   libpinyin
    #   rime
    #   typing-booster
    # ];
  };
}
