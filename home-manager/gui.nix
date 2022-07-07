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
    # appimage-run
    # zee
    # dippi
    # frei
    # mprober
    dynamic-wallpaper
    # clash-verge
    # app-icon-preview
    # librime-charcode
    # decoder
    # artem
    # paper
    # netease-cloud-music-gtk
    # g4music
    # gpu-viewer
    # frog
    code-radio-cli
    radioboat
    media-downloader
    video-trimmer
    image-roll

    gitg
    v2ray
    qv2ray
    proxychains-ng
    # clash
    # nur.repos.linyinfeng.clash-for-windows
    foot
    alacritty
    # wezterm
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
    fractal
    # nheko
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
    # ffmpeg
    mousai # 听歌识曲
    # easyeffects

    # Image manipulation
    # shutter
    yacreader
    contrast
    # gcolor3
    # wl-color-picker

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
    # glxinfo
    # libva-utils #vainfo
    # vulkan-tools
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
