{config, ...}: {
  home.shellAliases = {
    cat = "bat -p";
    ps = "ps -ef";
    beep = "echo -en \"\\007\"";
    age = "rage";
    cp = "rsync -ahv --progress";
    dirsize = "du -sh";
    rm = "trash-put";
    rm-list = "trash-list";
    rm-empty = "trash-empty";
    ip = "ip --color=auto";
    ipsb = "curl ip.sb";
    ipinfo = "curl ipinfo.io";

    ee = "emacs -nw";
    nctb = "nc termbin.com 9999";
    ixio = "curl -F 'f:1=<-' ix.io";
    ssr = "export http_proxy=http://127.0.0.1:20171 ; \\
    export https_proxy=http://127.0.0.1:20171";
    journalctl-1h = "journalctl -p err..alert --since \"60 min ago\"";

    nix-repl-pkgs = "nix repl '<nixpkgs>'";
    nse = "nix search nixpkgs";
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
