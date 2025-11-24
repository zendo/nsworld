{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wlsunset
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

  services.avizo.enable = true;

  services.swaync = {
    enable = true;
    settings = {
      notification-visibility = {
        bluetooth-connected = "never";
      };
    };
  };

  # https://darkman.whynothugo.nl/#CONFIGURATION
  services.darkman = {
    enable = true;
    settings = {
      usegeoclue = true;
      # lat = "";
      # lng = "";
      darkModeScripts = {
        gtk-theme = ''
          ${pkgs.dconf}/bin/dconf write \
              /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        '';
      };
      lightModeScripts = {
        gtk-theme = ''
          ${pkgs.dconf}/bin/dconf write \
              /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        '';
      };
    };
  };

  services.wlsunset = {
    enable = true;
    # gama = "2.0";
    temperature.night = 3000; # default: 4000
    # sunset = "19:00";
    # sunrise = "07:00";
    latitude = "22.38";
    longitude = "114.20";
  };
}
