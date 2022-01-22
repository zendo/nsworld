{ config, pkgs, ... }:

{
  system.stateVersion = "22.05";

  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = true; # Local time for dual OS

  hardware.enableAllFirmware = true; # contains non-redistributable firmware

  boot = {
    plymouth.enable = true;
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_latest; # latest zen xanmod
    # kernelParams = [ "mem_sleep_default=deep" ]; # s3 sleep
    # initrd.extraFiles = {  };
    cleanTmpDir = true;

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 3; # startup menu items
      systemd-boot.consoleMode = "max"; # resolution max for hidpi
    };
  };

  services = {
    fwupd.enable = true;

    # Monitoring health of drives
    smartd = {
      enable = true;
      autodetect = true;
    };

    fstrim = {
      enable = true;
      interval = "weekly";
    };

    # logind.lidSwitch = "suspend-then-hibernate";

    journald.extraConfig = ''
      SystemMaxUse=100M
    '';
  };

  # Hibernate after sleeping in suspend mode for 30 minutes
  # systemd.sleep.extraConfig = ''
  #   HandleSuspendKey=suspend-then-hibernate
  #   HandleHibernateKey=suspend-then-hibernate
  #   HandleLidSwitch=suspend-then-hibernate
  #   HibernateDelaySec=30min
  # '';

  #########################################################################
  # Sounds
  #########################################################################
  # Pipewire
  hardware.pulseaudio.enable = false; # false in pipewire
  security.rtkit.enable = true; # Realtime Policy and Watchdog Daemon
  services.pipewire = {
    enable = true;
    media-session.enable = false;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  # Musnix
  musnix.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  #########################################################################
  # i18n
  #########################################################################
  i18n.defaultLocale = "zh_CN.UTF-8";

  console.keyMap = "us";

  services.xserver = {
    layout = "us";

    libinput = {
      # enable = true; # enabled default by desktopManager
    };

    # xkbOptions = "ctrl:swapcaps"; # emacser habit on Xorg
  };

  #########################################################################
  # essential apps
  #########################################################################
  environment.systemPackages = with pkgs; [
    binutils
    tree
    p7zip
    fd
    ripgrep
    mg
    micro
    helix
    pfetch
    neofetch
    wget
    curl
    bind
    git
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };

  # environment.variables = {
  # };

  # Can not work without channels.
  programs.command-not-found.enable = false;

  documentation = {
    enable = false;
    nixos.enable = false;
  };

  #########################################################################
  # virtualisation
  #########################################################################
  virtualisation = {
    # docker = {
    #   enable = true;
    #   autoPrune.enable = true;
    #   enableOnBoot = true;
    # };

    # podman = {
    #   enable = true;
    #   dockerCompat = true;
    # };

    # libvirtd = {
    #   enable = true;
    #   qemu.runAsRoot = false;
    # };

    # waydroid.enable = true;
  };

  # services.flatpak.enable = true;

  # programs.steam.enable = true;

}
