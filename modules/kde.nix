{ config, pkgs, lib, ... }:

let
  hidpiEnable = config.hardware.video.hidpi.enable;
in
{
  services = {
    colord.enable = true;
    geoclue2.enable = true;
  };

  programs = {
    dconf.enable = true;
    kdeconnect.enable = true;
    partition-manager.enable = true;
  };

  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.login.enableGnomeKeyring = true;
  # programs.seahorse.enable = true;

  environment.systemPackages = with pkgs; [
    # falkon
    kalendar
    yakuake
    gparted
    kcolorchooser
    gnome.gnome-color-manager # broken?
  ] ++ (with libsForQt5; [
    ark
    juk
    kate
    kalk
    krfb
    krdc
    kgamma5 # broken?
    kweather
    ksystemlog
    kmousetool
    # kleopatra
    # konqueror
    # kcontacts
    # korganizer
  ]);

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-breeze
      rime-easy-en
      rime-aurora-pinyin
    ];
  };

  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];

    displayManager = {
      defaultSession = "plasmawayland";

      sddm = {
        enable = true;
        settings = {
          General.InputMethod = ""; # fix giant virtual keyboard
          X11.ServerArguments = lib.optionalString hidpiEnable "-dpi 144";
        };
      };

      lightdm = {
        enable = false;
        greeters.gtk = lib.optionalAttrs hidpiEnable {
          cursorTheme.size = 48;
          extraConfig = ''
            xft-dpi=261
            clock-format=%H:%M
          '';
          indicators = [
            "~spacer"
            "~clock"
            "~spacer"
            "~session"
            # "~language"
            # "~a11y"
            "~power"
          ];
        };
      };
    };

    desktopManager.plasma5 = {
      enable = true;
      supportDDC = true;
      # useQtScaling = true;
      excludePackages = with pkgs.libsForQt5; [
        # elisa
        # oxygen
        # khelpcenter
        # print-manager
        plasma-browser-integration
      ];
    };
  };
}
