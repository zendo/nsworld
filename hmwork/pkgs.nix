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

    # CLI
    dnspeep
    lsof
    elinks
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
    speedtest-cli
    translate-shell
    aspellDicts.en
    nyancat
    asciinema # record the terminal

    # GUI
    v2ray
    qv2ray
    firefox-wayland
    qbittorrent
    vlc
    mpv
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
    # vorta
    yacreader
    wezterm

    # OFFICE
    # libreoffice-fresh

    # Themes
    # tela-icon-theme
  ];

}
