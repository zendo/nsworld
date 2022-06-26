{
  config,
  pkgs,
  lib,
  ...
}: let
  btrfsInInitrd = lib.any (fs: fs == "btrfs") config.boot.initrd.supportedFilesystems;
  btrfsInSystem = lib.any (fs: fs == "btrfs") config.boot.supportedFilesystems;
  btrfsEnable = btrfsInInitrd && btrfsInSystem;
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
      configurationLimit = 5; # bootmenu items
    };
    # grub = {
    #   enable = true;
    #   device = "nodev";
    #   efiSupport = true;
    # };
  };

  services = {
    fwupd.enable = true;
    acpid.enable = true;

    journald.extraConfig = ''
      SystemMaxUse=500M
    '';

    btrfs.autoScrub.enable = lib.mkIf btrfsEnable true;
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

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Need channels
  programs.command-not-found.enable = false;

  documentation = {
    enable = false;
    nixos.enable = false;
  };

  system.stateVersion = "22.05";
}
