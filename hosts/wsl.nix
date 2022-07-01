{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
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
    curl
    nix-bash-completions

    hack-font
    fira-code
    jetbrains-mono
    emacs-all-the-icons-fonts
  ];

  environment.variables = {
  };

  environment.shellAliases = {
    wsl-proxy = "export http_proxy=http://192.168.2.118:7890 ; \\
    export https_proxy=http://192.168.2.118:7890";
    wsl-switch = "sudo -E nixos-rebuild switch --flake ~/.nsworld#wsl";
  };
}
