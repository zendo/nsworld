{ inputs, ... }:
# nix path-info -sh n#jq
let
  cli-apps =
    pkgs: with pkgs; [
      # [ Developing ]
      # yq
      yq-go # ~14 MiB
      jq
      jql
      # otree # tui tree for JSON/YAML/TOML
      sqlite
      openssl # ~16 MiB
      discount # :markdown
      efm-langserver # :markdown lsp
      shellcheck
      strace
      lurk # strace alternative
      herdr # ~30 MiB

      # [ Editor ]
      ttt # ~17 MiB
      # micro
      fresh-editor # ~40 MiB
      # zee
      # msedit
      typos # ~18 MiB
      ydict # ~11 MiB
      translate-shell
      # aspell
      # aspellDicts.en
      hunspell
      hunspellDicts.en_US

      # [ Git ]
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.wrapper-git
      # gh auth login
      # gh api rate_limit
      gh # ~43 MiB
      delta
      # difftastic # too big
      lazygit # ~22 MiB
      tokei # count code

      # [ Compressor/Archiver ]
      p7zip # ~11 MiB
      unzip
      ouch
      # patool
      # atool
      # cdrtools # mkisofs

      # [ FileManager ]
      eza
      bat
      fd
      ripgrep
      file # ~11 MiB
      tree
      # erdtree
      fzf
      skim
      yazi
      gdu # ~21 MiB
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
      # croc

      # [ FileServer ]
      rclone # ~108 MiB
      # python -m http.server 8080
      simple-http-server # :riir
      # sshfs [user@]hostname:[directory] MOUNTPOINT
      # umount MOUNTPOINT
      sshfs
      # dufs
      goshs # ~23 MiB
      sendme # ~13 MiB
      # magic-wormhole-rs
      # tailcat # 17.6 MiB

      # [ System Monitor ]
      # fastfetch -c examples/7 14
      fastfetch-unwrapped
      btop
      htop
      bottom
      ctop # containers monitor (~14 MiB)
      iotop-c
      dool # py fork of dstat
      powertop
      # psmisc # pstree
      procs

      # [ Utils ]
      # (lib.hiPrio uutils-coreutils-noprefix) # riir
      # moor # modern pager 16.1 MiB
      just
      # igrep
      cht-sh
      tlrc # tldr
      # tealdeer # tldr
      # asciinema # record the terminal
      libqalculate # ~11 MiB
      calcurse
      # kalker # calculator

      # [ Networking ]
      wget
      curl
      aria2
      # ghgrab
      lsof
      bind
      # doggo # ~14 MiB
      # q # dns (~11 MiB)
      # snitch
      # sniffglue
      # ipinfo # 62M
      # elinks
      # wthrr # weather
      # dnspeep
      # bandwhich
      # proxychains-ng
      # airgeddon # wifi crack

      # Game & fun
      clock-rs
      # curl parrot.live
      #$: fortune | cowsay -f tux | clolcat
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
in
{
  flake.modules.nixos.cli =
    { pkgs, ... }:
    {
      environment.systemPackages = cli-apps pkgs;
    };

  flake.modules.homeManager.cli =
    { pkgs, ... }:
    {
      home.packages = cli-apps pkgs;
    };

  flake.modules.hjem.cli =
    { pkgs, ... }:
    {
      packages = cli-apps pkgs;
    };
}
