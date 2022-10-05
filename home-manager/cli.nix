{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Overlays
    nixos-helper

    # Compressor / Archiver
    p7zip
    unzip
    unrar
    patool

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
    fd
    ripgrep
    hstr # hh: history
    cht-sh
    rage # age encrypt RIIR
    sd
    mc
    f2
    choose
    croc
    # difftastic # too big
    kalker # calculator
    # imagemagick
    ydict
    typos
    translate-shell
    aspellDicts.en
    asciinema # record the terminal
    # distrobox
    light
    viu # image viewer
    graphviz
    paperoni # save html
    # airgeddon # wifi crack
    magic-wormhole-rs
    joshuto
    zssh
    calcurse

    # Developing
    jq
    jql
    cloc # count code lines
    sqlite
    openssl
    gitui
    onefetch
    efm-langserver

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

    # Nix-tools
    nixpkgs-fmt
    nixfmt
    alejandra
    rnix-lsp
    lorri
    comma
    manix
    niv
    nvd
    cachix
    nixos-generators
    # nix-template
    nixpkgs-review
    nix-index
    nix-tree
    nix-top
    # nvfetcher
    shellcheck

    # Game for fun
    cava # Music Visualizer
    # pipes-rs
    # cbonsai
    # hollywood
  ];

  manual.manpages.enable = false;

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
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
