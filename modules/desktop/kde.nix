{
  flake.modules.nixos.kde =
    { pkgs, ... }:
    {
      services.desktopManager.plasma6.enable = true;
      services.displayManager.plasma-login-manager.enable = true;

      programs.kde-pim.enable = false;
      services.colord.enable = true;
      programs.kdeconnect.enable = true;
      programs.partition-manager.enable = true;

      environment.systemPackages =
        with pkgs;
        [
          gparted
          # [ plasma widgets ]
          kurve
          plasmusic-toolbar
        ]
        ++ (with kdePackages; [
          # yakuake
          kclock
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
    };
}
