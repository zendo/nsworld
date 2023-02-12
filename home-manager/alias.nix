{ config, pkgs, lib, ... }: {

  home.shellAliases = {
    cat = "bat -p";
    l = "exa -l --icons";
    "la." = "ls -d .*";
    rm = "trash-put";
    free = "free -h";
    tree = "${lib.getExe pkgs.erdtree}";
    bc = "${lib.getExe pkgs.libqalculate}";
    psp = "${lib.getExe pkgs.procs}";
    mount-ls = "mount | column -t";
    beep = "echo -en \"\\007\"";

    inxi = "inxi -Fz";
    ip = "ip --color=auto";
    nload = "nload devices wlp1s0";

    wttr = "curl \"wttr.in/Huadu\?0\&lang=zh\"";
    paste-ixio = "curl -F 'f:1=<-' ix.io";
    paste-gcg = ''curl -F "file=@-" gcg.sh'';
    paste-termbin = "nc termbin.com 9999";
    paste-rs = "curl --data-binary @- https://paste.rs/";
    paperoni-single-html = "paperoni --export html --inline-images";
    gg-doom = "git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d";
    gg-astronvim = "git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim";

    ee = "emacs -nw";
    nse = "nix search nixpkgs";
    ssr = "export {http,https,ftp}_proxy=127.0.0.1:7890 ;export {HTTP,HTTPS,FTP}_PROXY=127.0.0.1:7890";
    journalctl-1h = "journalctl -p err..alert --since \"60 min ago\"";
  };
}
