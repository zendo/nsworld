{ pkgs, ... }:
{
  services = {
    colord.enable = true;

    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
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
      gparted
      # sddm-astronaut
    ]
    ++ (with kdePackages; [
      yakuake
      krfb
      krdc
      kwave
      ksystemlog
      kcolorchooser
      karousel # Scrollable tiling wm
      # kleopatra
      # korganizer
    ]);

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    khelpcenter
    # print-manager
    plasma-browser-integration
  ];
}
