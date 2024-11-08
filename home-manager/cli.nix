{ config, pkgs, ... }:
{
  manual.manpages.enable = false;

  home.packages = with pkgs; [
    # Nix Tools
    # alejandra
    nixfmt-rfc-style
    # lorri
    # cachix
    # comma # ,
    nix-tree
    # nix-prefetch
    # nix-update
    # nix-template
    # nix-output-monitor

    # Developing
    yq
    jql
    igrep
    sqlite
    openssl
    discount # markdown
    efm-langserver # markdown lsp
    strace
    lurk # strace alternative

    # Compressor / Archiver
    p7zip
    unzip
    # unar # free but oversize
    unrar # unfree
    ouch
    patool
    # atool

    # FileManager
    f2
    sd
    choose
    ssh-to-age
    sops
    age
    # rage # age encrypt RIIR
    chafa # image viewer
    viu # image viewer
    trash-cli
    eget
    croc
    magic-wormhole-rs

    # System Monitor
    ctop # containers monitor
    iotop-c
    dstat
    powertop
    psmisc # pstree
    procs
    erdtree
    ikill
    gdu
    duf
    dysk
    tokei # count code

    # Utils
    just
    cht-sh
    # difftastic # too big
    kalker # calculator
    ydict
    typos
    shellcheck
    translate-shell
    aspellDicts.en
    # asciinema # record the terminal
    calcurse
    # zee

    # Networking
    lsof
    dogdns
    # nali
    mtr
    nload
    ipinfo
    elinks
    dnspeep
    nethogs
    bandwhich
    traceroute
    speedtest-cli
    proxychains-ng
    # airgeddon # wifi crack

    # Game & fun
    # pipes-rs
    # cbonsai
    # hollywood
    # nyancat
  ];

  programs = {
    aria2 = {
      enable = true;
    };

    eza = {
      enable = true;
    };

    bat = {
      enable = true;
    };

    fd = {
      enable = true;
    };

    jq = {
      enable = true;
    };

    btop = {
      enable = true;
    };

    # btm
    bottom = {
      enable = true;
    };

    ripgrep = {
      enable = true;
    };

    htop = {
      enable = true;
    };

    # hh :history
    hstr = {
      enable = true;
    };

    tealdeer = {
      enable = true;
    };

    fzf = {
      enable = true;
    };

    skim = {
      enable = true;
    };

    yazi = {
      enable = true;
    };

    # z: autojump directory
    zoxide = {
      enable = true;
    };

    # shell history
    # atuin login -u zendo
    # atuin sync -f
    atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
        # "--disable-ctrl-r"
      ];
      # settings = {
      #   auto_sync = true;
      #   sync_frequency = "5m";
      #   sync_address = "https://api.atuin.sh";
      #   search_mode = "prefix";
      # };
    };

    nix-index = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    micro = {
      enable = true;
      settings = {
        autosu = true;
        softwrap = true;
        hlsearch = true;
        saveundo = true;
        scrollbar = true;
        mkparents = true;
        diffgutter = true;
      };
    };
  };
}
