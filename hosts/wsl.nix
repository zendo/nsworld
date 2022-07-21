{
  config,
  pkgs,
  lib,
  username,
  ...
}: let
  winProxy = "http://192.168.2.118:10811";
in {
  /*
   export DISPLAY="`grep nameserver /etc/resolv.conf | sed 's/nameserver //'`:0"
   */

  wsl.defaultUser = lib.mkForce "${username}";

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "22.05";

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    parted
    gptfdisk
    wget
    nix-bash-completions

    vim
    micro
    helix
    emacs

    wsl-open
    hack-font
    fira-code
    jetbrains-mono
    emacs-all-the-icons-fonts
  ];

  environment.variables = {
  };

  environment.shellAliases = {
    wsl-proxy = "export http_proxy=${winProxy} ; \\
    export https_proxy=${winProxy}";
  };

  systemd.services.nix-daemon.environment = {
    http_proxy = "${winProxy}";
    https_proxy = "${winProxy}";
  };
}
