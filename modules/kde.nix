{ config, pkgs, ... }:

{
  services.xserver.displayManager = {
    sddm.enable = true;
    autoLogin.enable = true;
  };

  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  environment.libsForQt5.excludePackages = with pkgs; [
    # discover
  ];

  environment.systemPackages = with pkgs; [
    # libsForQt5.ark
    # libsForQt5.plasma-nm
    # libsForQt5.kate
    # libsForQt5.okular
    # libsForQt5.gwenview
    # libsForQt5.spectacle
    # libsForQt5.ksysguard
    # libsForQt5.kinfocenter
    # libsForQt5.kde-gtk-config
    # partition-manager
  ];


}
