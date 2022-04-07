{
  config,
  pkgs,
  ...
}: {
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
    wayland-utils
    # wdisplays # wlr

    # NIX TOOLS
    nix-bash-completions
    nixpkgs-fmt
    nixfmt
    alejandra # Nix Code Formatter
    rnix-lsp
    lorri
    comma
    manix
    niv
    nvd
    cachix
    # nvfetcher
    nixos-generators

    # Develop
    # gcc
    # cmake
    # gnumake
    # nodejs
    gitui
    bit
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
    ctop # containers monitor
    bottom # btm
    psmisc # pstree
    cht-sh
    trash-cli
    kalker # calculator
    imagemagick
    translate-shell
    magic-wormhole
    aspellDicts.en
    asciinema # record the terminal

    # overlay
    # harmonyos-sans
    zee

    gitg
    git-cola
    distrobox
    v2ray
    qv2ray
    # nur.repos.linyinfeng.clash-for-windows
    foot
    # wezterm
    alacritty

    (pkgs.google-chrome.override {
      commandLineArgs = "--ozone-platform-hint=auto --enable-features=VaapiVideoDecoder --use-gl=egl";
    })
    firefox-wayland
    # microsoft-edge

    qbittorrent
    mpv
    # vlc
    ffmpeg
    spotify
    mousai # 听歌识曲
    # easyeffects
    # shutter
    foliate
    rnote # handwritten note
    tdesktop
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
  ];
}
