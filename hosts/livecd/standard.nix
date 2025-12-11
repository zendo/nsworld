/*
  nix build .#nixosConfigurations.livecd-standard.config.system.build.isoImage
  qemu-system-x86_64 -enable-kvm -m 8192 -cdrom result/iso/
  https://wiki.nixos.org/wiki/Creating_a_NixOS_live_CD
*/
{
  self,
  pkgs,
  lib,
  myvars,
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
  ];

  environment.systemPackages = with pkgs; [ dippi ];

  boot = {
    tmp.useTmpfs = false;
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = {
      bcachefs = true;
      zfs = lib.mkForce false; # always broken
    };
  };

  services = {
    displayManager.autoLogin.user = "${myvars.user}";
    xserver = {
      # xkb.options = "ctrl:swapcaps"; # Xorg Layout
    };
  };

  users.users = {
    # pw: root
    root.initialHashedPassword = lib.mkImageMediaOverride "$y$j9T$IJdpnArgDAkYk8JS4NSWu.$z2HLJElOgWZz1rKDT7W38QdC9fXRXFdshJJug1.vzO8";
    # pw: live
    ${myvars.user}.initialHashedPassword =
      lib.mkImageMediaOverride "$y$j9T$uzMw3fo0epQjxDUOReFc2.$p.4FJdQ8X4Mr6aWf6FR2x7ks9byGP0p8.NNxx0zrIpC";
  };

  security.sudo-rs.enable = lib.mkImageMediaOverride false;

  nixpkgs.hostPlatform = "x86_64-linux";

  # fast but lowest compression level
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
