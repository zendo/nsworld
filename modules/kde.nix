{ config, pkgs, ... }:

{
  services.xserver.displayManager = {
    sddm.enable = true;
    # defaultSession = "plasmawayland";
    autoLogin.user = "iab";
  };

  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.runUsingSystemd = true;

  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.login.enableGnomeKeyring = true;

  services.colord.enable = true;

  programs.kdeconnect.enable = true;
  programs.partition-manager.enable = true;

  environment.systemPackages = with pkgs; [
    libsForQt5.ark
    libsForQt5.kate
    libsForQt5.kde-gtk-config
    libsForQt5.kompare

    libsForQt5.krdc
    libsForQt5.konqueror
    libsForQt5.kleopatra
    # libsForQt5.kcontacts
    # libsForQt5.korganizer
    neochat
    nheko
    gparted
    kcolorchooser
    gnome.gnome-calculator
    gnome.gnome-color-manager
  ];

  # tlp 与 rfkill 管理蓝牙冲突
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     cpu_scaling_governor_on_ac = "performance";
  #     cpu_scaling_governor_on_bat = "powersave";
  #     cpu_energy_perf_policy_on_ac = "balance_performance";
  #     cpu_energy_perf_policy_on_bat = "power";
  #   };
  # };


}
