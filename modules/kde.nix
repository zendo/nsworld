{ config, pkgs, ... }:

{
  services.xserver.displayManager = {
    sddm.enable = true;
    # defaultSession = "plasmawayland";
    autoLogin.enable = true;
  };

  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # export PLASMA_USE_QT_SCALING=1 in X11
  # https://bugs.kde.org/show_bug.cgi?id=356446
  services.xserver.desktopManager.plasma5.useQtScaling = true;

  services.dbus.packages = [ pkgs.libsForQt5.kpmcore ];

  environment.systemPackages = with pkgs; [
    libsForQt5.ark
    libsForQt5.kate
    libsForQt5.kde-gtk-config
    gparted
    kcolorchooser
    partition-manager
    gnome.gnome-calculator
    gnome.gnome-font-viewer
    gnome.gnome-color-manager
  ];

  programs.kdeconnect.enable = true;

  services.colord.enable = true;

  # tlp
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
