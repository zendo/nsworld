{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Nix Tools
    nixos-helper
    nixpkgs-fmt
    nixfmt
    alejandra
    # nil # lsp
    # rnix-lsp
    lorri
    # nvd # nix profile diff
    cachix
    nixos-generators
    # nix-template
    nix-update
    nixpkgs-review
    nix-index
    nix-tree
    nix-top
    comma # ,
    nix-alien # Run binaries
    nix-index-update
    # nix-output-monitor
    # nvfetcher

    # Developing
    jq
    jql
    cloc # count code lines
    sqlite
    openssl
    gitui
    onefetch
    efm-langserver # markdown lsp
    # distrobox
    gnumake
    # python3

    # Compressor / Archiver
    p7zip
    unzip
    unrar
    patool
    atool
    trash-cli

    # FileManager
    fd
    ripgrep
    f2
    sd
    choose
    rage # age encrypt RIIR
    lf
    ctpv
    viu # image viewer
    graphviz
    # imagemagick
    exiftool
    ffmpegthumbnailer
    eget
    zssh # SSH and Telnet client
    termscp
    croc
    magic-wormhole-rs

    # System Monitor
    btop
    ctop # containers monitor
    htop
    iotop-c
    dstat
    powertop
    bottom # btm
    psmisc # pstree
    ikill
    gdu
    duf
    neofetch

    # Utils
    hstr # hh: history
    cht-sh
    # difftastic # too big
    kalker # calculator
    ydict
    typos
    shellcheck
    translate-shell
    aspellDicts.en
    asciinema # record the terminal
    paperoni # save html
    calcurse

    # Networking
    lsof
    dogdns
    nali
    mtr
    nload
    ipinfo
    elinks
    dnspeep
    bandwhich
    traceroute
    speedtest-cli
    # airgeddon # wifi crack

    # Game & fun
    cava # Music Visualizer
    # pipes-rs
    # cbonsai
    # hollywood
  ];

  manual.manpages.enable = false;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.exa = {
    enable = true;
    # ll, la, lla, lt ...
    enableAliases = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.aria2 = {
    enable = true;
  };

  programs.tealdeer = {
    enable = true;
  };

  # z: autojump directory
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.skim = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
