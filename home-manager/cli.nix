{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # compressor / archiver packages
    p7zip
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
    gdu
    duf
    neofetch

    # tui utils
    fd
    ripgrep
    hstr # hh: history
    cht-sh
    rage # age encrypt RIIR
    mc
    f2
    choose
    croc
    # difftastic # too big
    kalker # calculator
    imagemagick
    dict
    ydict
    typos
    translate-shell
    aspellDicts.en
    asciinema # record the terminal
    distrobox
    graphviz
    paperoni # save html
    # airgeddon # wifi crack
    magic-wormhole-rs

    # Develop
    jq
    jql
    cloc # count code lines
    sqlite
    openssl
    gitui
    onefetch

    # Network
    lsof
    dogdns
    nali
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
    # nvfetcher
    shellcheck

    getip
    nixos-helper
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

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
