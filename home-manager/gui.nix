{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    anich # 在线动漫弹幕
    # azcomicv

    foot
    kitty
    kitten-quick-terminal # .desktop
    nix-init
    inputs.deploy-rs.packages.${system}.deploy-rs
    inputs.self.formatter.${system} # persistent cache

    tdesktop # (webkitgtk)
    # vesktop # discord
    # nheko
    # fluffychat
    # gui-for-singbox
    venera
    jhentai

    # Terminal
    cava
    ripdrag
    graphviz
    # imagemagick
    exiftool
    ffmpegthumbnailer
    # unar # free but oversize
    unrar # unfree

    # Multimedia
    spotify
    # qmmp
    # fooyin
    # (deadbeef-with-plugins.override {
    #   plugins = with deadbeefPlugins; [mpris2];
    # })
    # amberol
    audacious
    # rhythmbox
    goodvibes
    go-musicfox
    # mousai
    songrec
    kooha
    # jamesdsp
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
    foliate # (webkitgtk)
    # koodo-reader
    # planify
    # ghostwriter # (qtwebengine)
    meld
    # textpieces
    devtoolbox

    # HARDWARE TEST
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

    (writeScriptBin "nsearch" ''nix search nixpkgs "$@"'')
  ];

  services = {
    # disable on wm
    easyeffects.enable = !config.services.wlsunset.enable;
  };

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      # uosc
      inhibit-gnome
      thumbfast
      modernz
    ];
  };

  # programs.obs-studio = {
  #   enable = true;
  # };
}
