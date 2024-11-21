{
  lib,
  pkgs,
  config,
  ...
}:
{
  # zram
  zramSwap.enable = lib.mkDefault true;

  # zswap
  # systemd.tmpfiles.settings."zswap" = {
  #   "/sys/module/zswap/parameters/enabled"."w-".argument = "1";
  #   "/sys/module/zswap/parameters/zpool"."w-".argument = "zsmalloc";
  # };

  # systemd-oomd or earlyoom
  # systemd.oomd.enable = false;

  # Only enable on Desktop
  hardware.bluetooth.enable = config.services.graphical-desktop.enable;

  # This allows PipeWire to run with realtime privileges (i.e: less cracks)
  security.rtkit.enable = config.services.pipewire.enable;

  # Making `xdg-open` works inside FHS apps
  xdg.portal.xdgOpenUsePortal = true;

  boot = {
    plymouth.enable = true;

    tmp = {
      useTmpfs = lib.mkDefault true;
      cleanOnBoot = !config.boot.tmp.useTmpfs;
    };

    initrd.systemd = {
      enable = lib.mkDefault true;
      # root = "gpt-auto";
    };

    kernelParams = lib.optionals config.boot.initrd.systemd.enable [ "systemd.show_status=false" ];
  };

  services = {
    acpid.enable = true;
    # fwupd.enable = true;
    # earlyoom.enable = true;
    btrfs.autoScrub.enable = config.fileSystems."/".fsType == "btrfs";

    # auto-enabled by services.graphical-desktop
    pipewire = {
      # alsa.support32Bit = true;
      # jack.enable = true;
    };

    scx = {
      # enable = true;
      # scheduler = "scx_rustland";
    };

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
    binutils
    tree
    file
    wget
    curl
    parted
    gptfdisk
    micro
    sniffglue
    nix-bash-completions
    sbctl
    efibootmgr
    # efitools
  ];

  documentation = {
    enable = lib.mkDefault false;
    man.enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
  };

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "24.11";

  # Remove perl from activation
  # system.etc.overlay.enable = lib.mkDefault true;
}
