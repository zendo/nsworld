{ config, pkgs, ... }:

{
  system.stateVersion = "21.11";

  hardware.enableAllFirmware = true; # contains non-redistributable firmware

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 3; # startup menu items
    systemd-boot.consoleMode = "max"; # resolution max for hidpi
  };

  boot = {
    plymouth.enable = true;
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_zen; # latest or zen
    # kernelParams = [ "mem_sleep_default=deep" ]; # s3 sleep
    # initrd.extraFiles = {  };
  };

  services = {
    # logind.lidSwitch = "suspend-then-hibernate";

    fwupd.enable = true;

    # Monitoring health of drives
    smartd = {
      enable = true;
      autodetect = true;
    };

    # fstrim = "discard" in /etc/fstab
    fstrim = {
      enable = true;
      interval = "weekly";
    };

    # emacser habit
    xserver.xkbOptions = "ctrl:swapcaps";

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


  # Set your time zone
  time.timeZone = "Asia/Shanghai";

  # Local time for dual OS
  time.hardwareClockInLocalTime = true;

  # Sounds
  # sound.enable = true; # comment in pipewire
  hardware.pulseaudio.enable = false; # false in pipewire
  # Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true; #jack-device ?
  };

  # Musnix
  musnix.enable = true;

  # Handles input devices
  services.xserver.libinput = {
    # enable = true; # enabled default by desktopManager
    touchpad.disableWhileTyping = true;
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
    neofetch
    wget
    curl
    bind
    git
  ];

  # environment.variables = {
  # };

  # virtualisation
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      enableOnBoot = true;
    };

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

  documentation = {
    enable = false;
    nixos.enable = false;
  };

  #########################################################################
  # i18n
  #########################################################################
  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  console.keyMap = "us";

  services.xserver = {
    layout = "us";
  };

}
