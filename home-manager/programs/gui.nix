{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # anich # 在线动漫弹幕

    telegram-desktop # (webkitgtk)
    # vesktop # discord
    # fractal
    # fluffychat
    venera
    jhentai

    # Terminal
    cava
    graphviz
    # imagemagick
    exiftool
    ffmpegthumbnailer
    # unar # free but oversize
    unrar # unfree

    # Multimedia
    # mpd
    # rmpc
    # qmmp
    audacious
    # rhythmbox
    goodvibes
    # go-musicfox
    # splayer # (electron)
    qqmusic
    spotify
    # mousai
    songrec
    kooha
    # jamesdsp
    (mpv-unwrapped.wrapper {
      mpv = pkgs.mpv-unwrapped;
      youtubeSupport = false; # (yt-dlp)
      scripts = with pkgs.mpvScripts; [
        mpris
        # uosc
        inhibit-gnome
        thumbfast
        modernz
      ];
    })
    # yt-dlp
    # vlc
    # ffmpeg
    # ciano
    # video-trimmer

    # Image manipulation
    # shutter
    # pinta
    # yacreader
    contrast
    # font-manager # (webkitgtk)
    # gcolor3
    gradia
    satty # annotation

    # remmina # (webkitgtk)
    # gnome-decoder
    # https://github.com/nix-community/home-manager/issues/5173
    (lib.hiPrio localsend)
    qbittorrent
    # deja-dup
    # rclone
    # rclone-browser
    # vorta
    # qalculate-gtk # scientific calculator

    # OFFICE
    # libreoffice-fresh
    # drawio
    # rnote # handwritten note
    # foliate # (webkitgtk)
    readest
    # koodo-reader
    # planify
    # ghostwriter # (qtwebengine)
    meld
    # textpieces
    # devtoolbox

    # HARDWARE TOOLS
    parted
    gptfdisk
    efibootmgr
    # efitools
    # amdgpu_top
    # nvtopPackages.amd
    inxi
    lm_sensors
    lshw
    kmon # kernel modules
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
    xorg.xeyes
    # libinput
    wl-clipboard
    # squirreldisk
    mission-center
  ];

  # programs.obs-studio = {
  #   enable = true;
  #   plugins = [ ];
  # };

  programs.pandoc = {
    enable = false;
  };
}
