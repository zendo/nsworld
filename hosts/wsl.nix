{
  config,
  pkgs,
  lib,
  username,
  ...
}: let
  winProxy = "http://192.168.2.118:10811";
in {
  wsl.defaultUser = lib.mkForce "${username}";
  # users.defaultUserShell = pkgs.zsh;

  system.stateVersion = "22.05";
  time.timeZone = "Asia/Shanghai";

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
    # helix
    emacs

    kitty
    wsl-open
    radioboat
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.variables = {
  };

  # for zsh completion in home-manager
  environment.pathsToLink = [ "/share/zsh" ];

  environment.shellAliases = {
    wsl-proxy = "export {http,https,ftp}_proxy=${winProxy} ; \\
    export {HTTP,HTTPS,FTP}_PROXY=${winProxy}";
  };
}
