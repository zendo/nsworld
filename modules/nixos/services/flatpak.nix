{ config, pkgs, ... }:
{
  # flatpak install flathub io.github.kolunmi.Bazaar
  services.flatpak.enable = config.services.graphical-desktop.enable;

  systemd.services.flatpak-repo = {
    enable = config.services.flatpak.enable;
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
