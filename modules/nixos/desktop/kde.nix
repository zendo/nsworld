{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    # theme = "sddm-astronaut-theme";
  };

  services.colord.enable = true;
  programs.kdeconnect.enable = true;
  programs.partition-manager.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      gparted
      # sddm-astronaut
    ]
    ++ (with kdePackages; [
      # yakuake
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
    discover
    # print-manager
    plasma-browser-integration
  ];
}
