{ config, pkgs, ... }:

{
  system.stateVersion = "22.05";

  time.timeZone = "Asia/Shanghai";

  hardware.enableAllFirmware = true; # contains non-redistributable firmware

  boot = {
    plymouth.enable = true;
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_latest; # latest zen xanmod
    # kernelParams = [ "mem_sleep_default=deep" ]; # s3 sleep
    # initrd.extraFiles = {  };
    cleanTmpDir = true;

    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max"; # resolution max for hidpi
      systemd-boot.configurationLimit = 3; # startup menu items
      efi.canTouchEfiVariables = true;
    };
  };

  services = {
    fwupd.enable = true;

    # logind.lidSwitch = "suspend-then-hibernate";

    journald.extraConfig = ''
      SystemMaxUse=100M
    '';
  };


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
  # musnix.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Keyborad
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
    file
    p7zip
    fd
    ripgrep
    mg
    micro
    helix
    gdu
    duf
    pfetch
    neofetch
    parted
    gptfdisk
    wget
    curl
    bind
    git
  ];

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
