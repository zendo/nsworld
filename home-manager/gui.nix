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
    # mabel
    # mprober
    paper
    # converseen
    # app-icon-preview
    # done
    # textpieces
    # textsnatcher

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
    # poedit    # translate .po file

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
    celluloid
    # vlc
    # ffmpeg
    # audacious
    rhythmbox
    radioboat
    mousai # 听歌识曲
    # eartag
    jamesdsp
    # easyeffects
    # media-downloader

    # Image manipulation
    # shutter
    pinta
    yacreader
    contrast
    # gcolor3
    # wl-color-picker

    qbittorrent
    gnome-decoder
    meld
    # deja-dup
    # rclone
    # rclone-browser
    # vorta
    # qalculate-gtk # scientific calculator

    # OFFICE
    # libreoffice-fresh
    # rnote # handwritten note

    # Common devtools
    gnumake

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

  # Desktop Environment Hack
  home.file = {
    # Fix tiny cursor in qt apps at gnome
    ".icons/default/index.theme".text = lib.optionalString gnomeEnable ''
      [icon theme]
      Inherits=Adwaita
    '';

    # Fix flatpak font
    # ".local/share/flatpak/overrides/global".text = ''
    #   [Context]
    #   filesystems=/run/current-system/sw/share/X11/fonts:ro;/nix/store:ro
    # '';

    # ".local/share/fcitx5/themes".source = pkgs.fetchFromGitHub {
      #   owner = "icy-thought";
      #   repo = "fcitx5-catppuccin";
      #   rev = "3b699870fb2806404e305fe34a3d2541d8ed5ef5";
      #   sha256 = "hOAcjgj6jDWtCGMs4Gd49sAAOsovGXm++TKU3NhZt8w=";
      # };
  };

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
