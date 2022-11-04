{
  config,
  pkgs,
  lib,
  nixosConfig,
  ...
}: let
  gnomeEnable = nixosConfig.services.xserver.desktopManager.gnome.enable;
  hidpiEnable = nixosConfig.hardware.video.hidpi.enable;
in {
  services = {
    easyeffects.enable = true;
  };

  home.packages = with pkgs; [
    # app-icon-preview
    # converseen
    # done
    # retext
    # g4music
    # radio-cli
    # sauce
    iotas
    tiptop-py

    foot
    kitty
    # alacritty
    # wezterm
    warp
    remmina
    qv2ray
    # clash
    proxychains-ng
    # nur.repos.linyinfeng.clash-for-windows
    whatip
    sniffglue

    # Browsers
    # (google-chrome.override {
    #   commandLineArgs = [
    #     "--ozone-platform=wayland"
    #     "--enable-features=VaapiVideoDecoder"
    #     "--use-gl=egl"
    #   ];
    # })
    # microsoft-edge
    # vivaldi
    # vivaldi-ffmpeg-codecs
    # vivaldi-widevine
    # poedit    # translate .po file
    handlr

    # Social media
    tdesktop
    # fractal-next
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
    audacious
    # rhythmbox
    # radioboat
    # goodvibes
    # netease-cloud-music-gtk
    mousai # 听歌识曲
    # eartag
    # tagger
    # jamesdsp
    # media-downloader
    # spotdl
    spotiflyer

    # Image manipulation
    # shutter
    pinta
    # yacreader
    contrast
    # gcolor3
    # wl-color-picker

    # gitnuro
    qbittorrent
    gnome-decoder
    # deja-dup
    # rclone
    # rclone-browser
    # vorta
    # qalculate-gtk # scientific calculator

    # OFFICE
    # libreoffice-fresh
    # rnote # handwritten note
    paper-note
    endeavour
    ghostwriter
    textpieces
    meld

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
    GDK_SCALE = lib.optionalString hidpiEnable "2";
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

  # xdg.configFile = {
  #   "autostart/qv2ray.desktop".text = ''
  #     [Desktop Entry]
  #     Name=qv2ray
  #     GenericName=V2Ray Frontend
  #     Exec=bash -c "sleep 5; qv2ray"
  #     Terminal=false
  #     Icon=qv2ray
  #     Categories=Network
  #     Type=Application
  #     StartupNotify=false
  #     X-GNOME-Autostart-enabled=true
  #   '';
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
