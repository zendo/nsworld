{ config, pkgs, ... }:

# nixos-install --option substituters "https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org"

# sudo nix-channel --add https://mirrors.ustc.edu.cn/nix-channels/nixos-unstable nixos
# sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

# sudo nix-channel --add https://mirrors.ustc.edu.cn/nix-channels/nixos-21.11 nixos
# sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
# sudo nix-channel --update
# nix-shell '<home-manager>' -A install

# LC_ALL=C xdg-user-dirs-update --force

# flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub

# https://sub.fnf.one/link/6bZAqpNKobYVB4FP?sub=3&extend=1

# ext4 option "noatime" "nodiratime"
# btrfs option "compress=zstd" "autodefrag" "noatime"

{
  system.stateVersion = "21.11";

  nix = {
    package = pkgs.nixUnstable; # nix v2.5pre
    useSandbox = true;
    autoOptimiseStore = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    binaryCaches = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d --max-freed $((64 * 1024**3))";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };


  ############################################################################
  # Hardware
  ############################################################################

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true; # non-free firmware

  # Systemd-boot
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    systemd-boot.configurationLimit = 3; #限制启动项数量
    systemd-boot.consoleMode = "max"; #resolution max for hidpi
  };
  boot.plymouth.enable = true;

  boot = {
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_zen; # latest or zen
    # kernelParams = [ "mem_sleep_default=deep" ]; #深度睡眠
  };

  services = {
    # Monitoring health of drives
    smartd = {
      enable = true;
      autodetect = true;
    };
    # fstrim periodically
    # Noneed continuous TRIM "discard" in /etc/fstab
    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = true;

  # PowerManagement check cpufreq-info
  # 或许跟 gnome power-profiles-daemon 功能重叠？
  # powerManagement.cpuFreqGovernor = "ondemand";

  # TLP
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     # Disable too aggressive power-management autosuspend
  #     USB_AUTOSUSPEND = 0;
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #   };
  # };

  # Set your time zone
  time.timeZone = "Asia/Shanghai";
  networking.timeServers = [ "ntp.tuna.tsinghua.edu.cn" ];

  # Local time for dual OS
  time.hardwareClockInLocalTime = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Sounds
  #sound.enable = true; #comment in pipewire
  hardware.pulseaudio.enable = false; #false in pipewire

  # Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true; #jack-device ?
  };

  # Handles input devices
  services.xserver.libinput = {
    # enable = true; #enabled default by desktopManager
    touchpad.disableWhileTyping = true;
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  ###########################################################################
  # essential apps
  ###########################################################################
  environment.systemPackages = with pkgs; [
    binutils
    tree
    p7zip
    unrar
    duf
    gdu
    pydf
    ncdu
    fd
    ripgrep
    mg
    zile
    micro
    neofetch
    wget
    curl
    bind
    git
  ];

  environment.variables = {
    EDITOR = "mg";
    VISUAL = "mg";
  };

  # flatpak
  services.flatpak.enable = true;

  # programs.steam.enable = true;

  # virtualisation
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      enableOnBoot = true;
    };
  };

  ###########################################################################
  # i18n and Fonts
  ###########################################################################
  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";
  # i18n.supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];

  console.keyMap = "us";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
  };

  # Fonts
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      source-han-sans
      source-code-pro
      sarasa-gothic
      emacs-all-the-icons-fonts
      hack-font
      fira-code
      jetbrains-mono
      symbola
    ];
    fontconfig = {
      # subpixel.rgba = "rgb";
      defaultFonts = {
        monospace = [ "Sarsa Mono SC" "DejaVu Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans CJK SC" ];
        serif = [ "Noto Serif CJK SC" ];
      };
    };
  };


  #############################################################################
  # Networking and Security
  #############################################################################

  networking = {
    hostName = "nix";
    networkmanager.enable = true;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # defaultGateway = "192.168.2.1";
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    #interfaces.eno1.useDHCP = true;
    #interfaces.wlp1s0.useDHCP = true;
    nameservers = [
      "223.5.5.5"
      "223.6.6.6"
    ];
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Publish this server and its address on the network
  services.avahi = {
    enable = true;
    # nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # Open ports for avahi zeroconf
  # networking.firewall.allowedUDPPorts = [ 5353 ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # OpenSnitch
  # services.opensnitch.enable = true;
}
