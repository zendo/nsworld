{
  config,
  pkgs,
  ...
}: let
  dotConfig = "~/nsworld";
  httpProxy = "http://127.0.0.1:20171";
  socksProxy = "socks5://127.0.0.1:20170";
in {
  home.shellAliases = {
    cat = "bat -p";
    # ps = "ps -ef";
    ps = "${pkgs.procs}/bin/procs";
    l = "exa -l --icons";
    "la." = "ls -d .*";
    rm = "${pkgs.trash-cli}/bin/trash-put";
    rm-list = "${pkgs.trash-cli}/bin/trash-list";
    rm-empty = "${pkgs.trash-cli}/bin/trash-empty";
    mkcd = "mkdir -p $1 && cd $1";
    mount-ls = "mount | column -t";
    bc = "${pkgs.libqalculate}/bin/qalc";
    beep = "echo -en \"\\007\"";
    ip = "ip --color=auto";
    ipsb = "curl ip.sb";
    ipinfo = "curl ipinfo.io";
    iptoys = "dog ip @dns.toys";
    ipdig = "dig +short myip.opendns.com @208.67.222.222";
    netlog = "lsof -P -i -n";
    inxi = "inxi -Fz";

    ee = "emacs -nw";
    nctb = "nc termbin.com 9999";
    ixio = "curl -F 'f:1=<-' ix.io";
    wttr = "curl \"wttr.in/Huadu\?0\&lang=zh\"";
    ssr = "export http_proxy=${httpProxy} ;export https_proxy=${httpProxy}";
    chrome-proxy = "google-chrome-stable --proxy-server=\"${socksProxy}\"";
    journalctl-1h = "journalctl -p err..alert --since \"60 min ago\"";
    paperoni-single-html = "paperoni --export html --inline-images";
    dict-en = "dict -c ${../dotfiles/dict.conf}";

    nse = "nix search nixpkgs";
  };
}
