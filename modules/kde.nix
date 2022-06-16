{
  config,
  pkgs,
  username,
  ...
}: {
  services.xserver = {
    enable = true;
    excludePackages = [
      pkgs.xterm
    ];

    displayManager = {
      # sddm.enable = true; # wayland autologin bug
      lightdm.enable = true;
      defaultSession = "plasmawayland";
      autoLogin.user = "${username}";
    };

    desktopManager.plasma5 = {
      enable = true;
      supportDDC = true;
      # useQtScaling = true;
      runUsingSystemd = true;
    };
  };

  #############################################
  services = {
    colord.enable = true;
    geoclue2.enable = true;

    tlp = {
      enable = true;
      settings = {
        cpu_scaling_governor_on_ac = "performance";
        cpu_scaling_governor_on_bat = "powersave";
        cpu_energy_perf_policy_on_ac = "balance_performance";
        cpu_energy_perf_policy_on_bat = "power";

        DEVICES_TO_ENABLE_ON_STARTUP = "wifi bluetooth";
      };
    };
  };

  programs = {
    kdeconnect.enable = true;
    partition-manager.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "qt";
    };
  };

  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.login.enableGnomeKeyring = true;
  # programs.seahorse.enable = true;

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
    # libsForQt5.lightly # theme
    # latte-dock

    falkon
    kalendar
    yakuake
    gparted
    kcolorchooser
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.enableRimeData= true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      # fcitx5-chinese-addons
    ];
  };
}
