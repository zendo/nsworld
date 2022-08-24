{
  config,
  pkgs,
  ...
}: {
  home.shellAliases = {
    cat = "bat -p";
    # ps = "ps -ef";
    ps = "${pkgs.procs}/bin/procs";
    l = "exa -l --icons";
    "la." = "ls -d .*";
    bc = "${pkgs.libqalculate}/bin/qalc";
    rm = "${pkgs.trash-cli}/bin/trash-put";
    rm-list = "${pkgs.trash-cli}/bin/trash-list";
    rm-empty = "${pkgs.trash-cli}/bin/trash-empty";
    mkcd = "mkdir -p $1 && cd $1";
    mount-ls = "mount | column -t";
    beep = "echo -en \"\\007\"";
    inxi = "inxi -Fz";

    ip = "ip --color=auto";
    ip-sb = "curl ip.sb";
    ip-info = "curl ipinfo.io";
    netlog = "lsof -P -i -n";

    ee = "emacs -nw";
    wttr = "curl \"wttr.in/Huadu\?0\&lang=zh\"";
    paste-ixio = "curl -F 'f:1=<-' ix.io";
    paste-termbin = "nc termbin.com 9999";
    paste-rs = "curl --data-binary @- https://paste.rs/";
    journalctl-1h = "journalctl -p err..alert --since \"60 min ago\"";
    chrome-proxy = "google-chrome-stable --proxy-server=\"socks5://127.0.0.1:20170\"";
    ssr = "export {http,https,ftp}_proxy=127.0.0.1:20171 ;export {HTTP,HTTPS,FTP}_PROXY=127.0.0.1:20171";

    nse = "nix search nixpkgs";
    dict-en = "dict -c ${../dotfiles/dict.conf}";
    # radioboat = "radioboat --volume 100";
    paperoni-single-html = "paperoni --export html --inline-images";
  };
}
