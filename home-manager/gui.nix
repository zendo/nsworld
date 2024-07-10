{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    # nightpdf
    # azcomicv
    # moonfm

    kitty
    nurl
    # nix-init
    # nixpkgs-review
    inputs.deploy-rs.packages.x86_64-linux.deploy-rs

    # nheko
    # fractal
    # discord
    tdesktop # (webkitgtk)
    # nekoray
    # (pkgs.makeAutostartItem {
    #   name = "nekoray";
    #   package = pkgs.nekoray;
    # })

    # Terminal
    cava
    ripdrag
    graphviz
    # imagemagick
    exiftool
    ffmpegthumbnailer

    # Multimedia
    spotify
    # muzika
    # vlc
    # ffmpeg
    kooha
    qmmp
    # fooyin
    # (deadbeef-with-plugins.override {
    #   plugins = with deadbeefPlugins; [mpris2];
    # })
    # amberol
    # audacious
    # rhythmbox
    goodvibes
    go-musicfox
    # qcm
    # netease-cloud-music-gtk
    # mousai
    songrec
    # yt-dlp
    # media-downloader
    # eartag
    # tagger
    # jamesdsp
    # ciano
    # video-trimmer
    # spotiflyer
    # downonspot

    # Image manipulation
    # shutter
    # pinta
    # yacreader
    contrast
    # font-manager # (webkitgtk)
    # gcolor3
    # wl-color-picker

    warp
    # remmina # (webkitgtk)
    gnome-decoder
    localsend
    # motrix
    qbittorrent
    # deja-dup
    # rclone
    # rclone-browser
    # vorta
    # qalculate-gtk # scientific calculator
    # poedit    # translate .po file
    handlr # mime

    # OFFICE
    # libreoffice-fresh
    # drawio
    # rnote # handwritten note
    foliate # (webkitgtk)
    # koodo-reader
    # librum
    notes
    planify
    # endeavour
    # ghostwriter # (qtwebengine)
    # textpieces
    meld

    # HARDWARE TEST
    amdgpu_top
    nvtopPackages.amd
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
    # squirreldisk

    # libinput
    wallutils # lsmon getdpi wayinfo
    wayland-utils
    # wdisplays # wlr

    (writeScriptBin "nsearch" ''nix search nixpkgs "$@"'')
  ];

  services = {
    # disable on wm
    # easyeffects.enable = !config.services.greetd.enable;
  };

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      # uosc
      inhibit-gnome
    ];
  };

  # programs.obs-studio = {
  #   enable = true;
  # };
}
