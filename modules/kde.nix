{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #  libsForQt5.ark libsForQt5.plasma-nm libsForQt5.kate libsForQt5.okular libsForQt5.gwenview
    #  libsForQt5.spectacle libsForQt5.ksysguard libsForQt5.kinfocenter libsForQt5.kde-gtk-config
    #  partition-manager
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-qt
      fcitx5-configtool
    ];
  };

  # environment.variables = {
  #   GTK_IM_MODULE = "fcitx";
  #   QT_IM_MODULE  = "fcitx";
  #   XMODIFIERS    = "@im=fcitx";
  # };
}
