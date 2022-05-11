{
  config,
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    supportDDC = true;
    # useQtScaling = true;
    runUsingSystemd = true;
  };

  services.xserver.displayManager = {
    # sddm.enable = true; # wayland autologin bug
    lightdm.enable = true;
    defaultSession = "plasmawayland";
  };

  services.xserver.excludePackages = [
    pkgs.xterm
  ];

  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.login.enableGnomeKeyring = true;
  # programs.seahorse.enable = true;

  services.colord.enable = true;
  services.geoclue2.enable = true;

  programs.kdeconnect.enable = true;
  programs.partition-manager.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };

  environment.variables = {
    # wayland ozone support
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    libsForQt5.ark
    libsForQt5.kate
    libsForQt5.kcalc
    libsForQt5.kde-gtk-config
    libsForQt5.kmousetool
    # libsForQt5.kweather
    # libsForQt5.kgamma5          # not work

    libsForQt5.krdc
    libsForQt5.kleopatra
    # libsForQt5.konqueror
    # libsForQt5.kcontacts
    # libsForQt5.korganizer
    libsForQt5.bismuth # tiling layout
    # latte-dock

    falkon
    kalendar
    yakuake
    gparted
    kcolorchooser
  ];

  services.tlp = {
    enable = true;
    settings = {
      cpu_scaling_governor_on_ac = "performance";
      cpu_scaling_governor_on_bat = "powersave";
      cpu_energy_perf_policy_on_ac = "balance_performance";
      cpu_energy_perf_policy_on_bat = "power";

      DEVICES_TO_ENABLE_ON_STARTUP = "wifi bluetooth";
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      # fcitx5-chinese-addons
    ];
  };
}
