{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.shellAliases = {
    cat = "${lib.getExe pkgs.bat} -p";
    cp = "${lib.getExe pkgs.xcp}";
    l = "${lib.getExe pkgs.eza} -l --icons";
    lm = "${lib.getExe pkgs.eza} -l -a --reverse --sort=modified";
    "la." = "ls -d .*";
    rm = "${lib.getExe pkgs.gtrash} put";
    rm-empty = "${lib.getExe pkgs.gtrash} find --rm";
    rm-restore = "${lib.getExe pkgs.gtrash} restore";
    fcd = ''cd "$(find -type d | fzf --preview 'tree -C {} | head -200')"'';
    bc = "${lib.getExe pkgs.libqalculate}";
    sc = "systemctl";
    scu = "systemctl --user";
    ii = "xdg-open"; # Invoke-Item
    inxi = "inxi -Fz";
    free = "free -h";
    beep = ''echo -en "\007"'';
    mount-ls = "mount | column -t";
    dd-log = "sudo dd bs=8M oflag=sync,direct conv=fsync status=progress";
    psp = "${lib.getExe pkgs.procs} --sortd UsageMem";
    ps-sort = ''ps -ewwo pid,%cpu,%mem,nice,pri,rtprio,args --sort=-pcpu,-pid | awk -v filter="$1" 'NR==1 || tolower($0) ~ tolower(filter)' | less -e --header=1'';
    journalctl-1h = ''journalctl -p err..alert --since "60 min ago"'';

    # network
    ip = "ip --color=auto";
    ip-api = "curl ip-api.com";
    ip-info = "curl ipinfo.io";
    ip-location = "curl -s api.ip2location.io | jq .";
    where-am-i = "${pkgs.geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/where-am-i";
    paste-termbin = "nc termbin.com 9999";
    paste-rs = "curl --data-binary @- https://paste.rs/";
    gg-doom = "git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d";
    gg-astronvim = "git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim";

    # emacs
    e = "emacs -nw";
    ee = "emacsclient --create-frame";
    ee-config = "emacs --init-directory ~/.config/emacs";
    dired = ''emacsclient -nw -c -e "(dired default-directory)"'';
    magit = ''emacsclient -nw -c -e "(magit-status)"'';

    # nix
    j = "just --justfile=${config.home.homeDirectory}/nsworld/justfile";
    nix-build-package = ''nix build --impure --expr "(import <nixpkgs> {}).callPackage ./package.nix {}" -L'';
  };

  programs.zsh.shellAliases = {
    # nix
    nix-build-ls = "f() { nix build --print-out-paths --no-link nixpkgs#\$1 | xargs yazi }; f";

    # proxy
    # ssr_ip=localhost:7890 ; ssr ; ssr-nix-daemon
    ssr = "export {http,https,all}_proxy=socks5h://\${ssr_ip} ;export {HTTP,HTTPS,ALL}_PROXY=socks5h://\${ssr_ip}";
    ssr-chrome = ''google-chrome-stable --temp-profile --proxy-server="''${ssr_ip}"'';
    ssr-nix-daemon = ''
      sudo mkdir -p /run/systemd/system/nix-daemon.service.d/
      sudo tee /run/systemd/system/nix-daemon.service.d/override.conf << EOF
      [Service]
      Environment="http_proxy=socks5h://''${ssr_ip}"
      Environment="https_proxy=socks5h://''${ssr_ip}"
      Environment="all_proxy=socks5h://''${ssr_ip}"
      EOF
      sudo systemctl daemon-reload
      sudo systemctl restart nix-daemon
    '';
  };

  # programs.fish.shellAliases = ;
}
