{
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    excludePackages = [
      pkgs.xterm
    ];

    displayManager = {
      # sddm.enable = true;
      lightdm.enable = true;
      defaultSession = "plasmawayland";
    };

    desktopManager.plasma5 = {
      enable = true;
      supportDDC = true;
      # useQtScaling = true;
    };
  };

  #############################################
  services = {
    colord.enable = true;
    geoclue2.enable = true;

    tlp = {
      enable = false;
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
  };

  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.login.enableGnomeKeyring = true;
  # programs.seahorse.enable = true;

  environment.variables = {
    # wayland ozone support
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs;
    [
      falkon
      kalendar
      yakuake
      gparted
      kcolorchooser
    ]
    ++ (with libsForQt5; [
      ark
      kate
      kcalc
      kmousetool
      # kweather

      krdc
      # kleopatra
      # konqueror
      # kcontacts
      # korganizer
      bismuth # tiling layout
    ]);

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      # fcitx5-chinese-addons
    ];
  };
}
