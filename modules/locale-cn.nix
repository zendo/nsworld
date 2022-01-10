{ config, pkgs, ... }:

{
  # Fonts
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
      symbola
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Sarsa Mono SC" "DejaVu Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans CJK SC" ];
        serif = [ "Noto Serif CJK SC" ];
      };
    };
  };

  # ibus
  # i18n.inputMethod = {
  #   enabled = "ibus";
  #   ibus.engines = with pkgs.ibus-engines; [
  #     libpinyin
  #     rime
  #     typing-booster
  #   ];
  # };

  # fcitx5
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      libsForQt5.fcitx5-qt
      fcitx5-gtk
      fcitx5-rime
      fcitx5-configtool
      fcitx5-chinese-addons
    ];
  };
}
