{
  inputs,
  self,
  pkgs,
  lib,
  username,
  modulesPath,
  ...
}:
{
  imports = [
    ../disko/bcachefs-single.nix
    # ../disko/btrfs-subvolumes.nix
    ./hardware-configuration.nix

    self.nixosModules.gnome
    # self.nixosModules.kde
    # self.nixosModules.sway
    # self.nixosModules.hyprland
  ];

  mods = {
    # steam.enable = true;
    # daeWithConfig.enable = true;
  };

  users.mutableUsers = true;

  environment.systemPackages = with pkgs; [
    duf
    gdu
  ];

  # Desktop Envirment
  services = {
    displayManager.autoLogin.user = "${username}";
    xserver = {
      # enable = true;
      desktopManager = {
        # gnome.enable = true;
        # xfce.enable = true;
        # budgie.enable = true;
        # deepin.enable = true;
        # cinnamon.enable = true;
        # pantheon.enable = true;
        # enlightenment.enable = true;
        # mate.enable = true;
        # lxqt.enable = true;
      };
      xkb.options = "ctrl:swapcaps"; # Xorg Layout
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    # Systemd-boot
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/efi"; # default /boot
      systemd-boot.enable = true;
    };
  };

  # SSH
  services.openssh = {
    settings.PermitRootLogin = "yes";
  };

  # Clipboard shared for NixOS@Guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
