{
  config,
  pkgs,
  ...
}: let
  dotConfig = "~/.nsworld";
  httpProxy = "http://127.0.0.1:20171";
  socksProxy = "socks5://127.0.0.1:20170";
in {
  home.shellAliases = {
    cat = "bat -p";
    # ps = "ps -ef";
    ps = "${pkgs.procs}/bin/procs";
    l = "exa -l --icons";
    "la." = "ls -d .*";
    rm = "trash-put";
    rm-list = "trash-list";
    rm-empty = "trash-empty";
    mkcd = "mkdir -p $1 && cd $1";
    mount-ls = "mount | column -t";
    age = "rage";
    bc = "${pkgs.kalker}/bin/kalker";
    beep = "echo -en \"\\007\"";
    ip = "ip --color=auto";
    ipsb = "curl ip.sb";
    ipinfo = "curl ipinfo.io";
    ipdig = "dig +short myip.opendns.com @208.67.222.222";
    netlog = "lsof -P -i -n";
    inxi = "inxi -Fz";

    ee = "emacs -nw";
    gedit = "gnome-text-editor";
    nctb = "nc termbin.com 9999";
    ixio = "curl -F 'f:1=<-' ix.io";
    wttr = "curl \"wttr.in/Huadu\?0\&lang=zh\"";
    ssr = "export http_proxy=${httpProxy} ;export https_proxy=${httpProxy}";
    chrome-proxy = "google-chrome-stable --proxy-server=\"${socksProxy}\"";
    journalctl-1h = "journalctl -p err..alert --since \"60 min ago\"";
    paperoni-single-html = "paperoni --export html --inline-images";

    nse = "nix search nixpkgs";
    nss = "f() { nix shell nixpkgs\#\$1 }; f";
    nx = "f() { nix run nixpkgs\#\$1 -- $2; }; f";
    nix-which = "f() { readlink -f $(which $1) }; f";
    nix-references = "f() { nix-store -q --references $(nix-which $1) }; f";
    nix-depends = "f() { nix path-info -rsSh $(nix-which $1) }; f";
    nix-sri = "nix hash to-sri --type sha256";
    nix-pr-branch = "gh pr checkout -R NixOS/nixpkgs";
    nix-pr-run = "f() { nix run github:NixOS/nixpkgs/pull/$1/merge#$2 }; f";

    ns-profiles = "ls -la /nix/var/nix/profiles";
    ns-generations = "nix profile history --profile /nix/var/nix/profiles/system";
    ns-source = "readlink -f /nix/var/nix/profiles/system";
    ns-installed = "nix path-info --recursive /run/current-system";
    ns-diff = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
    ns-switch = "sudo -E nixos-rebuild switch --flake ${dotConfig}#$(hostname)";
    ns-boot = "sudo -E nixos-rebuild boot --flake ${dotConfig}#$(hostname)";
    ns-upgrade = "sudo -E nixos-rebuild boot --flake ${dotConfig}#$(hostname) \\
    --recreate-lock-file";
    hm-switch = "nix run nixpkgs#home-manager build switch -- --flake .#$(users)";
  };
}
