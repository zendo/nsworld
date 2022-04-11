{
  config,
  pkgs,
  ...
}: {
  system.stateVersion = "22.05";
  time.timeZone = "Asia/Shanghai";

  zramSwap.enable = true;
  hardware.enableAllFirmware = true;

  boot = {
    plymouth.enable = true;
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxPackages_latest; # latest zen xanmod
    # kernelParams = [ "mem_sleep_default=deep" ]; # s3 sleep
    # initrd.extraFiles = {  };
    tmpOnTmpfs = true;
    cleanTmpDir = true;

    loader.efi.canTouchEfiVariables = true;
    # boot.loader.efi.efiSysMountPoint = "/boot/efi"; # default /boot
    loader.systemd-boot = {
      enable = true;
      consoleMode = "max"; # resolution max for hidpi
      configurationLimit = 3; # bootmenu items
    };
    # loader.grub = {
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
  };

  # systemd.sleep.extraConfig = ''
  # HibernateDelaySec=10min
  # '';

  #########################################################################
  # Sounds
  #########################################################################
  # Pipewire
  hardware.pulseaudio.enable = false; # false in pipewire
  # This allows PipeWire to run with realtime privileges (i.e: less cracks)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;

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
  ];

  environment.variables = {
    # wayland ozone support
    # NIXOS_OZONE_WL = "1";

    # MOZ_DISABLE_CONTENT_SANDBOX = "1";
  };

  # Can not work without channels.
  programs.command-not-found.enable = false;

  programs.nix-ld.enable = true;

  documentation = {
    enable = false;
    nixos.enable = false;
  };
}
