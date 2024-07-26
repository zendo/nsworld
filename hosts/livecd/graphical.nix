/*
  remember remove nixconfig.nix
  "auto-allocate-uids" and "cgroups"
*/
{
  inputs,
  self,
  pkgs,
  lib,
  config,
  username,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"

    self.nixosModules.gnome
    # self.nixosModules.kde
    # self.nixosModules.sway
    # self.nixosModules.hyprland
  ];

  boot = {
    initrd.systemd.enable = false;
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = {
      bcachefs = true;
      # always broken
      zfs = lib.mkForce false;
    };
  };

  mods.virt.enable = false;

  environment.systemPackages = with pkgs; [ dippi ];

  services.xserver = {
    xkb.options = "ctrl:swapcaps"; # Xorg Layout
  };

  # password: livecd
  users.users.${username}.hashedPassword = lib.mkForce "$y$j9T$rpwQr.lgxCy.V92cSxZcX1$fIUOx3Xx0vI7G/0R/DPI7IHjFAsUc0trqcuzJo7xGY2";

  networking.wireless.enable = lib.mkImageMediaOverride false;

  # fast but lowest compression level
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
