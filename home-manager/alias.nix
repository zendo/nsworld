{ lib, pkgs, ... }:
{
  home.shellAliases = {
    cat = "${lib.getExe pkgs.bat} -p";
    l = "${lib.getExe pkgs.eza} -l --icons";
    "la." = "ls -d .*";
    rm = "${pkgs.trash-cli}/bin/trash-put";
    rm-empty = "${pkgs.trash-cli}/bin/trash-empty";
    rm-restore = "${pkgs.trash-cli}/bin/trash-restore";
    free = "free -h";
    bc = "${lib.getExe pkgs.libqalculate}";
    psp = "${lib.getExe pkgs.procs} --sortd UsageMem";
    ps-sort = ''ps -ewwo pid,%cpu,%mem,nice,pri,rtprio,args --sort=-pcpu,-pid | awk -v filter="$1" 'NR==1 || tolower($0) ~ tolower(filter)' | less -e --header=1'';
    mount-ls = "mount | column -t";
    beep = ''echo -en "\007"'';

    inxi = "inxi -Fz";
    ip = "ip --color=auto";
    nload = "${lib.getExe pkgs.nload} devices wlp1s0";

    wttr = ''curl "wttr.in/Huadu?0&lang=zh"'';
    where-am-i = "${pkgs.geoclue2}/libexec/geoclue-2.0/demos/where-am-i";
    my-location = ''curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | jq -r '"\(.location.lat):\(.location.lng)"' '';
    paste-termbin = "nc termbin.com 9999";
    paste-rs = "curl --data-binary @- https://paste.rs/";

    nse = "nix search nixpkgs";
    ee = "emacsclient --create-frame";
    ee-config = "emacs --init-directory ~/.config/emacs";
    ssr = "export {http,https,ftp}_proxy=socks5h://127.0.0.1:7897 ;export {HTTP,HTTPS,FTP}_PROXY=socks5h://127.0.0.1:7897";
    journalctl-1h = ''journalctl -p err..alert --since "60 min ago"'';
    nix-build-default = ''nix-build -E "(import <nixpkgs> {}).callPackage ./. {}"'';
    # nix-build-package = ''nix-build -E "(import <nixpkgs> {}).callPackage ./package.nix {}"'';
    nix-build-package = ''nix build --impure --expr "(import <nixpkgs> {}).callPackage ./package.nix {}" -L'';
  };
}
