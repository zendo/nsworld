{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  boot = {
    initrd.systemd = {
      enable = lib.mkDefault true;
    };
    tmp = {
      useTmpfs = lib.mkDefault true;
      cleanOnBoot = lib.mkDefault true;
    };
  };

  services = {
    acpid.enable = true;
    # fwupd.enable = true;
    btrfs.autoScrub.enable = config.fileSystems."/".fsType == "btrfs";
    journald.extraConfig = ''
      SystemMaxUse=50M
    '';
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    command-not-found = {
      # enable = true;
      dbPath = inputs.nixpkgs + "/programs.sqlite";
    };
  };

  environment.systemPackages = with pkgs; [
    (lib.hiPrio uutils-coreutils-noprefix)
    tree
    file
    wget
    curl
    parted
    gptfdisk
    micro
    sbctl
    efibootmgr
    # efitools
  ];

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.05";
  documentation.enable = lib.mkDefault false;

  # Remove perl from activation
  # system.etc.overlay.enable = lib.mkDefault true;
}
