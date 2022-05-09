{
  config,
  pkgs,
  lib,
  ...
}:
with config.boot;
with lib; let
  btrfsInInitrd = any (fs: fs == "btrfs") initrd.supportedFilesystems;
  btrfsInSystem = any (fs: fs == "btrfs") supportedFilesystems;
  enableBtrfs = btrfsInInitrd && btrfsInSystem;
in {
  time.timeZone = "Asia/Shanghai";

  hardware.enableAllFirmware = true;

  zramSwap.enable = true;

  boot = {
    plymouth.enable = true;
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # latest zen xanmod_latest
    # kernelParams = [ "mem_sleep_default=deep" ]; # s3 sleep
    # initrd.extraFiles = {  };
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
    # logind.lidSwitch = "suspend-then-hibernate";
    # logind.extraConfig = ''
    # HandlePowerKey=ignore
    # '';

    journald.extraConfig = ''
      SystemMaxUse=500M
    '';

    btrfs.autoScrub.enable = mkIf enableBtrfs true;
  };

  # systemd.sleep.extraConfig = ''
  # HibernateDelaySec=10min
  # '';

  services.xserver = {
    libinput = {
      # enable = true; # enabled default by desktopManager
    };

    # xkbOptions = "ctrl:swapcaps"; # emacser habit on Xorg
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
    # wayland ozone support
    # NIXOS_OZONE_WL = "1";
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
