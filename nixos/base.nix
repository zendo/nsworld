{
  lib,
  pkgs,
  config,
  ...
}:
{
  # zramSwap.enable = lib.mkDefault true;

  boot = {
    plymouth.enable = true;

    tmp = {
      useTmpfs = lib.mkDefault true;
      cleanOnBoot = lib.mkDefault true;
    };

    initrd.systemd = {
      enable = lib.mkDefault true;
    };

    # Silent Boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = lib.optionals config.boot.plymouth.enable [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
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
    zsh.enable = true;
    command-not-found.enable = false;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
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
    sniffglue
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
