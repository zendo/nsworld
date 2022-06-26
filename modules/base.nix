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
    # kernelParams = ["quite"];
    tmpOnTmpfs = true;
    cleanTmpDir = true;
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
