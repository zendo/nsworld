{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # overlay
    # harmonyos-sans
    # zee
    # dialect
    # konsave
    # frog
    paper
    dippi
    # rymdport

    gitg
    # git-cola
    v2ray
    qv2ray
    # clash
    # nur.repos.linyinfeng.clash-for-windows
    foot
    # wezterm
    alacritty

    # (pkgs.google-chrome.override {
    #   commandLineArgs = "--ozone-platform-hint=auto --enable-features=VaapiVideoDecoder --use-gl=egl";
    # })
    # firefox-wayland
    # microsoft-edge

    qbittorrent
    mpv
    # vlc
    ffmpeg
    spotify
    mousai # 听歌识曲
    # easyeffects
    # shutter
    # foliate
    rnote # handwritten note
    # tdesktop
    # kotatogram-desktop
    meld
    deja-dup
    # rclone
    # rclone-browser
    # vorta
    yacreader
    # qalculate-gtk # scientific calculator
    # bottles # wine manager
    # yuzu

    # OFFICE
    # libreoffice-fresh

    # Themes
    # tela-icon-theme
    # vanilla-dmz

    # HARDWARE TEST
    efitools
    efibootmgr
    inxi
    lshw
    hwinfo
    cpu-x
    cpufetch
    acpi
    usbutils
    dmidecode
    glxinfo
    libva-utils #vainfo
    vulkan-tools
    cpufrequtils
    pciutils
    edid-decode
    # libinput
    wallutils # lsmon getdpi wayinfo
    wayland-utils
    # wdisplays # wlr
  ];

  xdg.configFile = {
      "mpv".source = ../dotfiles/mpv;
      "foot/foot.ini".source = ../dotfiles/foot.ini;
      "wezterm/wezterm.lua".source = ../dotfiles/wezterm.lua;
      "alacritty/alacritty.yml".source = ../dotfiles/alacritty.yml;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  # not work?
  programs.chromium = {
    enable = false;
    package = pkgs.google-chrome;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=VaapiVideoDecoder"
    ];
  };
}
