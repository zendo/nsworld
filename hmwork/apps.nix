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
  home.stateVersion = "21.11";
  home.username = "iab";
  home.homeDirectory = "/home/iab";

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
    manix
    nix-bash-completions
    nixos-option
    nixpkgs-fmt
    nixfmt
    rnix-lsp
    direnv
    lorri
    niv

    # develop
    gnumake
    tig
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
    btop
    zenith
    cht-sh
    trash-cli
    fzf
    skim
    unp
    imagemagick
    speedtest-cli
    translate-shell
    aspellDicts.en

    # GUI
    v2ray
    qv2ray
    # emacsGit
    # emacsPgtkGcc
    firefox-wayland
    qbittorrent
    vlc
    # ffmpeg
    # rhythmbox
    audacious
    spotify-2k
    # gimp
    shutter
    foliate
    yacreader
    ghostwriter
    tdesktop
    meld
    vorta
    deja-dup
    # standardnotes

    # OFFICE
    # libreoffice-fresh

    # Themes
    # tela-icon-theme
  ];

}
