{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Overlays
    # zee
    # mprober
    # dippi
    # frei
    dynamic-wallpaper

    gitg
    v2ray
    qv2ray
    proxychains-ng
    # clash
    # nur.repos.linyinfeng.clash-for-windows
    foot
    alacritty
    # magic-wormhole # python
    magic-wormhole-rs
    warp

    # Browsers
    # (google-chrome.override {
    #   commandLineArgs = "--ozone-platform-hint=auto --enable-features=VaapiVideoDecoder --use-gl=egl";
    # })
    # microsoft-edge
    # vivaldi
    # vivaldi-ffmpeg-codecs
    # vivaldi-widevine

    # Social media
    tdesktop
    # nheko
    fractal
    # discord

    # Multi-media
    qbittorrent
    mpv
    # vlc
    ffmpeg
    amberol
    # spotify
    # (spotify.override {
    #   deviceScaleFactor = 2;
    # })
    mousai # 听歌识曲
    # shortwave
    # easyeffects

    # Image manipulation
    # shutter
    yacreader

    meld
    # deja-dup
    # rclone
    # rclone-browser
    # vorta
    # qalculate-gtk # scientific calculator
    # bottles # wine manager
    # yuzu
    # gnome.gnome-boxes

    # OFFICE
    # libreoffice-fresh
    # rnote # handwritten note

    # HARDWARE TEST
    efibootmgr
    # efitools
    inxi
    lm_sensors
    lshw
    hwinfo
    cpufetch
    usbutils
    dmidecode
    glxinfo
    libva-utils #vainfo
    vulkan-tools
    cpufrequtils
    pciutils
    edid-decode
    read-edid

    # libinput
    wallutils # lsmon getdpi wayinfo
    wayland-utils
    # wdisplays # wlr
  ];

  programs.pandoc = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  # not work?
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = [
    #   "--ozone-platform=wayland"
      "--enable-features=VaapiVideoDecoder"
    ];
  };
}
