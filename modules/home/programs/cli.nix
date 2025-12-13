{ pkgs, ... }:
{
  manual.manpages.enable = false;

  home.packages = with pkgs; [
    # Developing
    yq
    jql
    # otree # tui tree for JSON/YAML/TOML
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
    file
    tree
    erdtree
    gdu
    duf
    dysk
    f2
    sd
    xcp
    choose
    rsync
    lazyssh
    ssh-to-age
    sops
    age
    # rage # age encrypt RIIR
    chafa # image viewer
    viu # image viewer
    gtrash
    croc
    # sshfs [user@]hostname:[directory] mountpoint
    # umount mountpoint
    sshfs
    dufs
    goshs
    simple-http-server
    magic-wormhole-rs

    # System Monitor
    fastfetchMinimal
    ctop # containers monitor
    iotop-c
    dool # py fork of dstat
    powertop
    psmisc # pstree
    procs
    ikill

    # Utils
    (lib.hiPrio uutils-coreutils-noprefix) # riir
    bat
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
    wthrr # weather
    dnspeep
    nethogs
    bandwhich
    traceroute
    speedtest-cli
    # proxychains-ng
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
    eza.enable = true;
    fd.enable = true;
    fzf.enable = true;
    skim.enable = true;
    ripgrep.enable = true;
    television.enable = true;
    jq.enable = true;
    yazi.enable = true;
    aria2.enable = true;
    btop.enable = true;
    htop.enable = true;
    bottom.enable = true; # btm
    hstr.enable = true; # hh :history
    zoxide.enable = true; # z: autojump directory
    # pay-respects.enable = true;
  };
}
