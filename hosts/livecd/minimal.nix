{
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    # "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    # "${modulesPath}/installer/cd-dvd/installation-cd-graphical-plasma6.nix"
    # "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = {
      # bcachefs = true;
      zfs = lib.mkForce false; # always broken
    };
  };

  environment.systemPackages = with pkgs; [
    tree
    file
    wget
    curl
    micro
    parted
    gptfdisk
    efibootmgr

    bind
    fd
    ripgrep
    gdu
    duf
    btop
    p7zip
    ouch
  ];

  hardware.enableAllFirmware = true;

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config.allowUnfree = true;
  };

  nix.settings = {
    # substituters = lib.mkForce [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
    trusted-users = [ "@wheel" ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  time.timeZone = "Asia/Shanghai";
}
