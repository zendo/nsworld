{ config, pkgs, lib, nixosConfig, ... }:

let
  hidpiEnable = nixosConfig.hardware.video.hidpi.enable;
  gnomeEnable = nixosConfig.services.xserver.desktopManager.gnome.enable;
in
{
  home.packages = with pkgs; [
    # iotas
    # nightpdf
    # cavalier
    justfortest
    # (opera.override { proprietaryCodecs = true; })
    # clash-verge
    # (makeAutostartItem { name = "clash-verge"; package = clash-verge; })

    # nur.repos.linyinfeng.clash-for-windows
    # nur.repos.rewine.aliyunpan
    # nur.repos.yes.lx-music-desktop
    nur.repos.rewine.electron-netease-cloud-music
    yesplaymusic

    foot
    kitty
    alacritty
    # wezterm
    warp
    remmina # (webkitgtk)
    # clash-verge
    # qv2ray
    # clash
    proxychains-ng
    whatip
    sniffglue

    # Browsers
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=VaapiVideoDecoder"
        "--use-gl=egl"
      ];
    })
    # microsoft-edge-beta
    # vivaldi
    # vivaldi-ffmpeg-codecs
    # vivaldi-widevine
    # poedit    # translate .po file
    handlr # mime

    # Social media
    tdesktop # (webkitgtk)
    # nheko
    # fractal-next
    # discord

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

    # OFFICE
    # libreoffice-fresh
    # drawio
    # rnote # handwritten note
    # foliate # (webkitgtk)
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
    # package = pkgs.firefox-bin;
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
    # Fix tiny cursor in qt-apps at gnome
    ".icons/default/index.theme".text = lib.optionalString gnomeEnable ''
      [icon theme]
      Inherits=Adwaita
    '';

    # Fix flatpak font
    # ".local/share/flatpak/overrides/global".text = ''
    #   [Context]
    #   filesystems=/run/current-system/sw/share/X11/fonts:ro;/nix/store:ro
    # '';
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
