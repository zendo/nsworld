{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Overlays
    harmonyos-sans
    misans
    # zee
    # mprober
    # dippi

    gitg
    v2ray
    qv2ray
    # clash
    # nur.repos.linyinfeng.clash-for-windows
    foot
    alacritty
    qdirstat

    # (pkgs.google-chrome.override {
    #   commandLineArgs = "--ozone-platform-hint=auto --enable-features=VaapiVideoDecoder --use-gl=egl";
    # })
    # microsoft-edge
    # vivaldi
    # vivaldi-ffmpeg-codecs
    # vivaldi-widevine

    qbittorrent
    mpv
    # vlc
    ffmpeg
    spotify
    mousai # 听歌识曲
    # shortwave
    # easyeffects
    # shutter
    tdesktop
    # nheko
    fractal
    # discord
    meld
    # deja-dup
    # rclone
    # rclone-browser
    # vorta
    yacreader
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

    # Override
    # (pkgs.google-chrome.override {
    #   commandLineArgs = "--ozone-platform-hint=auto --enable-features=VaapiVideoDecoder --use-gl=egl";
    # })
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  # not work?
  programs.chromium = {
    enable = false;
    package = pkgs.google-chrome;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=VaapiVideoDecoder"
    ];
  };
}
