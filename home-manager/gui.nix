{ config, pkgs, lib, nixosConfig, ... }:

let
  hidpiEnable = nixosConfig.hardware.video.hidpi.enable;
  gnomeEnable = nixosConfig.services.xserver.desktopManager.gnome.enable;
in
{
  home.packages = with pkgs; [
    iotas
    nightpdf
    azcomicv
    # clash-verge
    # (makeAutostartItem { name = "clash-verge"; package = clash-verge; })

    # foot
    kitty
    # alacritty
    warp
    whatip
    remmina # (webkitgtk)

    # Browsers
    # (google-chrome.override {
    #   commandLineArgs = [
    #     "--enable-features=VaapiVideoDecoder"
    #     "--use-gl=egl"
    #   ];
    # })
    # (vivaldi.override {
    #   proprietaryCodecs = true;
    #   enableWidevine = true; # drm
    # })
    # (opera.override { proprietaryCodecs = true; })
    # microsoft-edge-beta
    # nheko
    # fractal-next
    # discord
    tdesktop # (webkitgtk)

    # Multi-media
    (spotify.override {
      deviceScaleFactor = 2;
    })
    # spot # Premium accounts!
    # vlc
    # ffmpeg
    kooha
    qmmp
    # audacious
    # rhythmbox
    goodvibes
    go-musicfox
    # netease-cloud-music-gtk
    mousai # 听歌识曲
    # eartag
    # tagger
    # jamesdsp
    # ciano
    # video-trimmer
    # media-downloader
    # spotiflyer

    # Image manipulation
    # shutter
    # pinta
    yacreader
    contrast
    # font-manager # (webkitgtk)
    # gcolor3
    # wl-color-picker

    # motrix
    qbittorrent
    # gnome-decoder
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
    # foliate # (webkitgtk)
    # standardnotes
    # paper-note
    # endeavour
    ghostwriter
    # textpieces
    meld

    # HARDWARE TEST
    nvtop-amd
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
    xorg.xeyes

    # libinput
    wallutils # lsmon getdpi wayinfo
    wayland-utils
    # wdisplays # wlr
  ];

  services = {
    easyeffects.enable = true;
  };

  programs.mpv = {
    enable = true;
  };

  # programs.obs-studio = {
  #   enable = true;
  # };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    # profiles."default".extraConfig = ''
    #   # drm
    #   "media.eme.enabled" = true;

    #   # Hide bookmarks
    #   "browser.toolbars.bookmarks.visibility" = "never";

    #   # Dont show warning when accessing about:config
    #   "browser.aboutConfig.showWarning" = false;
    # '';
  };

  #######################################################################
  ##  Desktop Environment
  #######################################################################
  home.sessionVariables = {
    _JAVA_OPTIONS = lib.optionalString hidpiEnable "-Dsun.java2d.uiScale=2";
  };

  home.file = {
    # Fix qt tiny cursor on gnome
    ".icons/default/index.theme".text = lib.optionalString gnomeEnable ''
      [icon theme]
      Inherits=Adwaita
    '';
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # xdg.mimeApps = {
  #   enable = true;
  #   defaultApplications = {
  #     "text/html" = "re.sonny.Junction.desktop";
  #   };
  # };

  # xdg.desktopEntries.spotify = lib.options gnomeEnable {
  #   name = "Spotify";
  #   genericName = "Music Player";
  #   icon = "spotify-client";
  #   exec = "spotify %U --force-device-scale-factor=2";
  #   terminal = false;
  #   categories = ["Application" "Music"];
  # };
}
