{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    comigo

    # AI
    opencode

    # obsidian
    # joplin-desktop
    telegram-desktop # (webkitgtk)
    # vesktop # discord
    # fractal
    # fluffychat
    # newsflash
    venera
    jhentai

    # Terminal
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
    go-musicfox
    # splayer # (electron)
    # qqmusic
    spotify
    # mousai
    songrec
    kooha
    # jamesdsp
    (mpv.override {
      youtubeSupport = false; # (yt-dlp)
      scripts = with pkgs.mpvScripts; [
        mpris
        # uosc
        inhibit-gnome
        thumbfast
        modernz
      ];
    })
    kazumi # anime
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
    # gopeed
    # lock
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
    clapgrep
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
    xeyes
    wl-clipboard
    # libinput
    android-tools
    # squirreldisk
    resources
    # mission-center
  ];

  # programs.obs-studio = {
  #   enable = true;
  #   plugins = [ ];
  # };

  programs.pandoc = {
    enable = false;
  };
}
