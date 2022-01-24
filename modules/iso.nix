# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix

{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ./network.nix
  ];

  system.stateVersion = "22.05";

  time.timeZone = "Asia/Shanghai";
  hardware.enableAllFirmware = true; # contains non-redistributable firmware

  boot = {
    supportedFilesystems = [ "ntfs" "bcachefs"];
    # kernelPackages = pkgs.linuxPackages_latest; # latest zen xanmod
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
  nix.binaryCaches = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
      "https://nix-community.cachix.org"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];

  # programs that should be available in the installer
  environment.systemPackages = with pkgs; [
    binutils
    fish
    bcachefs-tools
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
    wget
    curl
    bind
    git
  ];
}
