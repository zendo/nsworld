# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix

{config, pkgs, modulesPath, lib, ...}:
{
  imports = [
    # <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix>
    # <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
    ./network.nix
  ];

  system.stateVersion = "22.05";

  time.timeZone = "Asia/Shanghai";

  hardware.enableAllFirmware = true;

  boot = {
    supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
    kernelPackages = pkgs.linuxPackages_latest; # latest zen xanmod
  };

  # Keyborad
  console.keyMap = "us";

  services.xserver = {
    layout = "us";

    libinput = {
      # enable = true; # enabled default by desktopManager
    };

    xkbOptions = "ctrl:swapcaps"; # emacser habit on Xorg
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nix.extraOptions = ''
      experimental-features = nix-command flakes
      '';
  nix.binaryCaches = lib.mkBefore [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
    ];

  environment.systemPackages = with pkgs; [
    binutils
    fish
    tree
    p7zip
    fd
    ripgrep
    mg
    micro
    helix
    pfetch
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
