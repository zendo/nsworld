{ config, pkgs, ... }:

{
  home = {
    stateVersion = "22.05";
    username = "iab";
    homeDirectory = "/home/iab";
  };

  programs.home-manager.enable = true;

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
    cpufrequtils
    pciutils
    edid-decode

    # NIX TOOLS
    nix-bash-completions
    nixpkgs-fmt
    nixfmt
    rnix-lsp
    direnv
    lorri
    niv
    # nvd diff /nix/var/nix/profiles/system-{14,15}-link
    nvd
    cachix

    # Develop
    # gcc
    # cmake
    # gnumake
    # nodejs
    gitui
    lazygit
    jq
    jql
    sqlite
    openssl
    python3

    # Network
    lsof
    elinks
    dnspeep
    bandwhich
    traceroute
    speedtest-cli
    v2ray
    qv2ray

    # CLI
    powertop
    unp
    unrar
    gdu
    duf
    btop
    bottom
    cht-sh
    trash-cli
    imagemagick
    translate-shell
    aspellDicts.en
    nyancat
    asciinema # record the terminal

    # GUI
    firefox-wayland
    # chromium
    # google-chrome
    qbittorrent
    vlc
    # kooha
    # simplescreenrecorder # Xorg
    # ffmpeg
    audacious
    spotify
    # shutter
    foliate
    ghostwriter
    tdesktop
    meld
    deja-dup
    rclone
    rclone-browser
    # vorta
    yacreader
    wezterm

    # OFFICE
    # libreoffice-fresh

    # Themes
    # tela-icon-theme
  ];

}
