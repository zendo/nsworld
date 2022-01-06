{ config, pkgs, ... }:

let
  spotify-2k = pkgs.symlinkJoin {
    name = "spotify";
    paths = [ pkgs.spotify ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/spotify \
        --add-flags "--force-device-scale-factor=1.8"
    '';
  };

in
{
  home = {
    stateVersion = "21.11";
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
    # nur.repos.xe.comma # Not support flake now
    nix-bash-completions
    nixpkgs-fmt
    nixfmt
    rnix-lsp
    direnv
    lorri
    niv
    cachix

    # develop
    # gcc
    # cmake
    # gnumake
    # nodejs
    gitui
    lazygit
    jq
    jql
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
    zenith
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
    # emacsGit
    # emacsPgtkGcc
    firefox-wayland
    qbittorrent
    vlc
    mpv
    simplescreenrecorder
    # ffmpeg
    audacious
    spotify-2k
    # shutter
    foliate
    ghostwriter
    tdesktop
    meld
    deja-dup
    # vorta
    yacreader

    # OFFICE
    # libreoffice-fresh

    # Themes
    # tela-icon-theme
  ];

}
