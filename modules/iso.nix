{ config, pkgs, modulesPath, lib, ... }:
{
  imports = [
    # "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  ];

  system.stateVersion = "22.05";
  time.timeZone = "Asia/Shanghai";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  hardware.enableAllFirmware = true;

  boot = {
    supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
    kernelPackages = pkgs.linuxPackages_latest; # latest zen xanmod
  };

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
  };

  services.xserver = {
    libinput = {
      # enable = true; # enabled default by desktopManager
      touchpad = {
        tapping = true;
        clickMethod = "buttonareas";
      };
    };
    # xkbOptions = "ctrl:swapcaps"; # emacser habit on Xorg
  };


  nix.settings = {
    substituters = lib.mkBefore [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];

    trusted-users = [ "@wheel" ];
    trusted-substituters = [
    ]; # List of binary cache URLs that non-root users can use
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  environment.systemPackages = with pkgs; [
    binutils
    fish
    tree
    p7zip
    unrar
    fd
    ripgrep
    vim
    mg
    micro
    neofetch
    parted
    gptfdisk
    gparted
    wget
    curl
    bind
    git
  ];
}
