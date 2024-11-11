{ pkgs, ... }:
{
  mods.fcitx.enable = true;

  services = {
    colord.enable = true;
    geoclue2.enable = true;

    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      # theme = "sddm-astronaut-theme";
    };
  };

  programs = {
    kdeconnect.enable = true;
    partition-manager.enable = true;
  };

  environment.systemPackages =
    with pkgs;
    [
      merkuro
      yakuake
      gparted
      kcolorchooser
      # sddm-astronaut
    ]
    ++ (with kdePackages; [
      krfb
      krdc
      ksystemlog
      # kleopatra
      # korganizer
    ]);

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    # elisa
    # khelpcenter
    # print-manager
    plasma-browser-integration
  ];
}
