{
  config,
  pkgs,
  lib,
  ...
}: let
  btrfsInInitrd = lib.any (fs: fs == "btrfs") config.boot.initrd.supportedFilesystems;
  btrfsInSystem = lib.any (fs: fs == "btrfs") config.boot.supportedFilesystems;
  enableBtrfs = btrfsInInitrd && btrfsInSystem;
in {
  time.timeZone = "Asia/Shanghai";

  hardware.enableAllFirmware = true;

  zramSwap.enable = true;

  boot = {
    plymouth.enable = true;
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # latest zen xanmod_latest
    # kernelParams = ["quite"];
    tmpOnTmpfs = true;
    cleanTmpDir = true;
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    # boot.efi.efiSysMountPoint = "/boot/efi"; # default /boot
    systemd-boot = {
      enable = true;
      consoleMode = "max"; # resolution max for hidpi
      configurationLimit = 5; # bootmenu items
    };
    # grub = {
    #   enable = true;
    #   device = "nodev";
    #   default = "2";
    #   efiSupport = true;
    #   useOSProber = true;
    #   gfxmodeEfi = "1024x768";
    # };
  };

  services = {
    fwupd.enable = true;
    acpid.enable = true;

    journald.extraConfig = ''
      SystemMaxUse=500M
    '';

    btrfs.autoScrub.enable = lib.mkIf enableBtrfs true;
  };

  #########################################################################
  # Essential Apps
  #########################################################################
  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    p7zip
    fd
    ripgrep
    gdu
    duf
    neofetch
    parted
    gptfdisk
    wget
    curl
    bind
    git
    nix-bash-completions
  ];

  environment.variables = {
  };

  # programs.nix-ld.enable = true;

  # Can not work without channels.
  programs.command-not-found.enable = false;

  documentation = {
    enable = false;
    nixos.enable = false;
  };

  system.stateVersion = "22.05";
}
