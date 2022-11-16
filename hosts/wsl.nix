{
  config,
  pkgs,
  username,
  ...
}: let
  winProxy = "http://192.168.2.118:10811";
in {
  networking.hostName = "wsl";

  wsl = {
    enable = true;
    defaultUser = "${username}";
    startMenuLaunchers = true;
    # wslConf.automount.root = "/mnt"; # defult
    # Not working!!
    # nativeSystemd = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  # users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    parted
    gptfdisk
    wget
    nix-bash-completions

    emacs

    mpg123 # for ydict
    kitty
    wsl-open
    goodvibes
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

  documentation.enable = false;
  documentation.nixos.enable = false;
  programs.command-not-found.enable = false;

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "22.05";
}
