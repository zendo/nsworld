{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # compressor / archiver packages
    unzip
    unrar
    patool

    # system monitor
    btop
    ctop # containers monitor
    powertop
    bottom # btm
    psmisc # pstree
    ikill

    # tui utils
    hstr # hh: history
    cht-sh
    tealdeer
    trash-cli
    rage # age encrypt RIIR
    mc
    f2
    choose
    croc
    difftastic # using delta right now
    kalker # calculator
    imagemagick
    ydict
    typos
    translate-shell
    # magic-wormhole # python
    magic-wormhole-rs
    aspellDicts.en
    asciinema # record the terminal
    distrobox
    graphviz
    paperoni # save html
    # airgeddon # wifi crack

    # Develop
    # gcc
    # cmake
    # gnumake
    # nodejs
    # yarn
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

    # NIX TOOLS
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
    nix-template
    nix-index
    nix-tree
    home-manager
    # nvfetcher
    nix-index-updatedb
  ];

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

  # z: autojump
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

  programs.tealdeer = {
    enable = true;
  };

  programs.nix-index = {
    enable = false;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  home.stateVersion = "22.05";
}
