/*
  https://wiki.nixos.org/wiki/Creating_a_NixOS_live_CD

  https://github.com/NixOS/nix/issues/8911
  --option auto-allocate-uids false
*/
{
  self,
  pkgs,
  lib,
  username,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"

    self.nixosModules.default
    self.nixosModules.homeManagerInit

    self.nixosModules.gnome
    # self.nixosModules.kde
    # self.nixosModules.sway
    # self.nixosModules.hyprland
  ];

  mods.virt.enable = false;

  boot = {
    tmp.useTmpfs = false;
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = {
      # bcachefs = true;
      zfs = lib.mkForce false; # always broken
    };
  };

  services = {
    displayManager.autoLogin.user = "${username}";
    xserver = {
      # xkb.options = "ctrl:swapcaps"; # Xorg Layout
    };
  };

  users.users = {
    # passwd: root
    root.initialHashedPassword = lib.mkForce "$y$j9T$8/wRQiclXB6j79eGn8FKp.$MayXuTGruzrN4kDOUXSIJhPUg3BLdL69EOERDXRRQq.";
    # psaawd: live
    ${username}.initialHashedPassword =
      lib.mkForce "$y$j9T$0VrmGqGBIdqClS5ndapJv0$sJDzKPsSQdM2bm9Z.o1TI1alC46LMWgIFf14CbSSoWB";
  };

  environment.systemPackages = with pkgs; [ dippi ];

  networking.wireless.enable = lib.mkImageMediaOverride false;

  nixpkgs.hostPlatform = "x86_64-linux";

  # fast but lowest compression level
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
