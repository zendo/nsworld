{config, ...}: {
  home.shellAliases = {
    cat = "bat -p";
    ps = "ps -ef";
    l = "exa -l --icons";
    "la." = "ls -d .*";
    rm = "trash-put";
    rm-list = "trash-list";
    rm-empty = "trash-empty";
    mount-ls = "mount | column -t";
    age = "rage";
    beep = "echo -en \"\\007\"";
    ip = "ip --color=auto";
    ipsb = "curl ip.sb";
    ipinfo = "curl ipinfo.io";
    ipdig = "dig +short myip.opendns.com @208.67.222.222";
    netlog = "lsof -P -i -n";
    inxi = "inxi -Fz";

    ee = "emacs -nw";
    nctb = "nc termbin.com 9999";
    ixio = "curl -F 'f:1=<-' ix.io";
    wttr = "curl \"wttr.in/Huadu\?0\&lang=zh\"";
    ssr = "export http_proxy=http://127.0.0.1:20171 ; \\
    export https_proxy=http://127.0.0.1:20171";
    journalctl-1h = "journalctl -p err..alert --since \"60 min ago\"";
    gedit = "gnome-text-editor";

    nse = "nix search nixpkgs";
    nx = "f() { nix run nixpkgs\#\$1; }; f";
    nix-repl-pkgs = "nix repl '<nixpkgs>'";
    nix-sri = "nix hash to-sri --type sha256";
    ns-profiles = "ls -la /nix/var/nix/profiles";
    ns-generations = "nix profile history --profile /nix/var/nix/profiles/system";
    ns-source = "readlink -f /nix/var/nix/profiles/system";
    ns-installed = "nix path-info --recursive /run/current-system";
    ns-diff = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
    ns-switch = "sudo -E nixos-rebuild switch --flake ~/.nsworld#$(hostname)";
    ns-boot = "sudo -E nixos-rebuild boot --flake ~/.nsworld#$(hostname)";
    ns-upgrade = "sudo -E nixos-rebuild boot --flake ~/.nsworld#$(hostname) \\
    --recreate-lock-file";
    ns-upgrade-now = "sudo -E nixos-rebuild switch --flake ~/.nsworld#$(hostname) \\
    --recreate-lock-file";
  };
}
