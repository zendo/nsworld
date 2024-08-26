{
  inputs,
  self,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    # ./disko-btrfs.nix
    ./disko-bcachefs.nix
    ./hardware-configuration.nix

    self.nixosModules.gnome
    # self.nixosModules.kde
    # self.nixosModules.sway
    # self.nixosModules.hyprland
  ];

  # services.flatpak.enable = true;

  mods.virt.enable = false;

  environment.systemPackages = with pkgs; [
    duf
    gdu
  ];

  # Desktop Envirment
  services.xserver = {
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
    # displayManager.autoLogin.user = lib.mkForce "guest";
    xkb.options = "ctrl:swapcaps"; # Xorg Layout
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    # Systemd-boot
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/efi";
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
