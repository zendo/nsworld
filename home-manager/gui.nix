{
  config,
  pkgs,
  lib,
  nixosConfig,
  ...
}: let
  gnomeEnable = nixosConfig.services.xserver.desktopManager.gnome.enable;
in {
  home.packages = with pkgs; [
    # Overlays
    # steam-run
    # (appimage-run.override {
    #   extraPkgs = pkgs: [ pkgs.libthai ];
    # })
    # zee
    # dippi
    # frei
    # mprober
    # dynamic-wallpaper
    # clash-verge
    # netease-cloud-music-gtk
    # app-icon-preview
    # paper
    # librime-charcode
      video-trimmer

    gitg
    v2ray
    qv2ray
    proxychains-ng
    # clash
    # nur.repos.linyinfeng.clash-for-windows
    foot
    alacritty
    warp

    # Browsers
    # google-chrome
    (google-chrome.override {
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--enable-features=VaapiVideoDecoder"
        "--use-gl=egl"
      ];
    })
    # microsoft-edge
    # vivaldi
    # vivaldi-ffmpeg-codecs
    # vivaldi-widevine
    vscode

    # Social media
    tdesktop
    # nheko
    fractal
    # discord

    # Multi-media
    (
      if gnomeEnable
      then
        (spotify.override {
          deviceScaleFactor = 2;
        })
      else spotify
    )
    mpv
    # vlc
    ffmpeg
    mousai # 听歌识曲
    # shortwave
    # easyeffects

    # Image manipulation
    # shutter
    yacreader

    qbittorrent
    meld
    # deja-dup
    # rclone
    # rclone-browser
    # vorta
    # qalculate-gtk # scientific calculator

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
    enable = false;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };
}
