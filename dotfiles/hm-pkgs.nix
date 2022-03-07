{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # HARDWARE TEST
    efitools
    efibootmgr
    inxi
    lshw
    hwinfo
    cpu-x
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
    # wdisplays # wlr

    # NIX TOOLS
    nix-bash-completions
    nixpkgs-fmt
    nixfmt
    rnix-lsp
    lorri
    comma
    manix
    niv
    nvd
    cachix
    nvfetcher
    nixos-generators

    # Develop
    # gcc
    # cmake
    # gnumake
    # nodejs
    gitui
    onefetch
    jq
    jql
    cloc # count code lines
    sqlite
    openssl
    python3

    # Network
    lsof
    mtr
    elinks
    dnspeep
    bandwhich
    traceroute
    speedtest-cli

    # CLI
    powertop
    unp
    unrar
    btop
    bottom # btm
    psmisc # pstree
    cht-sh
    trash-cli
    imagemagick
    translate-shell
    magic-wormhole
    aspellDicts.en
    asciinema # record the terminal

    # overlay
    # ydict
    # harmonyos-sans

    git-cola
    distrobox
    v2ray
    qv2ray
    foot
    # alacritty
    # wezterm
    # google-chrome
    qbittorrent
    # kooha
    mpv
    ffmpeg
    audacious
    spotify
    mousai # 听歌识曲
    # easyeffects
    # shutter
    foliate
    ghostwriter
    # tdesktop
    kotatogram-desktop
    meld
    deja-dup
    # rclone
    # rclone-browser
    # vorta
    yacreader
    # bottles # wine manager

    # OFFICE
    # libreoffice-fresh

    # Themes
    # tela-icon-theme
    # vanilla-dmz
  ];

}
