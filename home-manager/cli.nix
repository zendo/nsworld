{ pkgs, config, ... }:
{
  manual.manpages.enable = false;

  home.packages = with pkgs; [
    # Developing
    yq
    jql
    otree # tui tree for JSON/YAML/TOML
    sqlite
    openssl
    discount # markdown
    efm-langserver # markdown lsp
    strace
    lurk # strace alternative

    # Compressor / Archiver
    p7zip
    unzip
    ouch
    # patool
    # atool
    cdrtools # mkisofs

    # FileManager
    f2
    sd
    xcp
    choose
    lazyssh
    ssh-to-age
    sops
    age
    # rage # age encrypt RIIR
    chafa # image viewer
    viu # image viewer
    gtrash
    eget
    croc
    goshs
    dufs
    # sshfs
    simple-http-server
    magic-wormhole-rs

    # System Monitor
    ctop # containers monitor
    iotop-c
    dool # py fork of dstat
    powertop
    psmisc # pstree
    procs
    erdtree
    ikill
    gdu
    duf
    dysk

    # Utils
    just
    igrep
    cht-sh
    tlrc # tldr
    # tealdeer # tldr
    # difftastic # too big
    # kalker # calculator
    ydict
    typos
    shellcheck
    translate-shell
    # aspell
    # aspellDicts.en
    hunspell
    hunspellDicts.en_US
    # asciinema # record the terminal
    calcurse
    # zee
    tokei # count code
    wthrr # weather

    # Networking
    wget
    curl
    lsof
    dogdns
    q # dns
    # nali
    mtr
    nload
    sniffglue
    # ipinfo # 62M
    elinks
    dnspeep
    nethogs
    bandwhich
    traceroute
    speedtest-cli
    proxychains-ng
    # airgeddon # wifi crack

    # Game & fun
    clock-rs
    # curl parrot.live
    # fortune | cowsay -f tux | lolcat
    sl
    cowsay
    # xcowsay
    fortune
    # figlet
    # toilet
    clolcat
    cmatrix
    # lavat
    # cbonsai
    # pipes-rs
    # hollywood
    # snowmachine
    # oneko
    nyancat
    asciiquarium
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
      # enable = true;
    };

    fzf = {
      enable = true;
    };

    skim = {
      enable = true;
    };

    television = {
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

    pay-respects = {
      # enable = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = false;
      settings = {
        command_timeout = 3000; # Timeout for commands executed
        # add_newline = false; # Print a new line at the start of the prompt
        # line_break.disabled = true; # Make prompt a single line instead of two lines
        # cmd_duration.disabled = true; # disable "It took xxs"
        # character = {
        #   success_symbol = "[>](bold green)";
        #   error_symbol = "[✗](bold red)";
        # };
        # nix_shell = {
        #   format = "❄️ via [☃️ $state( \($name\))](bold blue)";
        #   symbol = "nix ";
        # };
      };
    };

    zellij = {
      # enable = true;
      settings = {
        theme = "nord";
        default_shell = "zsh";
        simplified_ui = true;
        pane_frames = false;
        keybinds = {
          unbind = "Ctrl q";
        };
      };
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
