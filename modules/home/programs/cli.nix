{
  flake.modules.homeManager.cli =
    { pkgs, ... }:
    {
      manual.manpages.enable = false;

      programs = {
        fzf.enable = true;
        skim.enable = true;
        television.enable = true;
        yazi.enable = true;
        aria2.enable = true;
        zoxide.enable = true; # z: autojump directory
        # hstr.enable = true; # hh: history
        # pay-respects.enable = true;
      };

      home.packages = with pkgs; [
        # [ Developing ]
        yq
        jq
        jql
        # otree # tui tree for JSON/YAML/TOML
        sqlite
        openssl
        discount # :markdown
        efm-langserver # :markdown lsp
        strace
        lurk # strace alternative

        # [ Compressor/Archiver ]
        p7zip
        unzip
        ouch
        # patool
        # atool
        cdrtools # mkisofs

        # [ FileManager ]
        eza
        fd
        ripgrep
        file
        tree
        # erdtree
        gdu
        duf
        dysk
        f2
        sd
        xcp
        choose
        rsync
        lazyssh
        chafa # image viewer
        viu # image viewer
        gtrash
        croc
        # sshfs [user@]hostname:[directory] mountpoint
        # umount mountpoint
        sshfs
        dufs
        goshs
        rclone
        simple-http-server
        # magic-wormhole-rs
        sendme

        # [ System Monitor ]
        microfetch
        fastfetchMinimal
        btop
        htop
        bottom
        ctop # containers monitor
        iotop-c
        dool # py fork of dstat
        powertop
        psmisc # pstree
        procs
        ikill

        # [ Utils ]
        # (lib.hiPrio uutils-coreutils-noprefix) # riir
        bat
        just
        # igrep
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

        # [ Networking ]
        wget
        curl
        # ghgrab
        lsof
        bind
        doggo
        q # dns
        # nali
        mtr
        nload
        snitch
        sniffglue
        # ipinfo # 62M
        # elinks
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
        # asciiquarium # :perl
      ];
    };
}
