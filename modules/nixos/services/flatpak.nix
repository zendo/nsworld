{ config, ... }:
{
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # flatpak install flathub io.github.kolunmi.Bazaar
  services.flatpak.enable = config.services.graphical-desktop.enable;
}
