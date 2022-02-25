{ config, pkgs, ... }:

{
  home = {
    stateVersion = "22.05";
    username = "iab";
    # homeDirectory = "/home/iab";
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
    niv
    # nvd diff /nix/var/nix/profiles/system-{14,15}-link
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
    btop
    bottom # btm
    psmisc # pstree
    cht-sh
    trash-cli
    imagemagick
    translate-shell
    aspellDicts.en
    asciinema # record the terminal

    # overlay
    # ydict
    # harmonyos-sans

    # GUI
    # google-chrome
    qbittorrent
    # vlc
    # kooha
    # ffmpeg
    audacious
    spotify
    # tauon
    # easyeffects
    # shutter
    foliate
    ghostwriter
    tdesktop
    meld
    deja-dup
    # rclone
    # rclone-browser
    # vorta
    yacreader
    # wezterm
    # bottles # wine like

    # OFFICE
    # libreoffice-fresh

    # Themes
    # tela-icon-theme
    # vanilla-dmz
  ];

}
