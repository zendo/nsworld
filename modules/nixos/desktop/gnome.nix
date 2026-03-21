{
  flake.modules.nixos.gnome =
    { pkgs, ... }:
    {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      # services.gnome.tinysparql.enable = false;
      # services.gnome.localsearch.enable = false;
      services.packagekit.enable = false;

      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      };

      environment.gnome.excludePackages = with pkgs; [
        sushi # heavyweight
        yelp
        gnome-tour
        gnome-music
        gnome-software
        showtime
        simple-scan
      ];

      environment.systemPackages = with pkgs; [
        # authenticator
        refine
        # file-roller
        # peazip
        xarchiver
        gthumb
        gparted
        dconf-editor
        gnome-randr
        gnome-power-manager
        gnome-sound-recorder
        # gnome-extension-manager
        # adw-gtk3
        qadwaitadecorations-qt6
      ];
    };
}
