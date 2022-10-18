{
  config,
  pkgs,
  username,
  modulesPath,
  ...
}: let
  winProxy = "http://192.168.2.118:10811";
in {
  imports = [
    ../modules/nix.nix
    ../modules/fonts.nix
    # "${modulesPath}/profiles/minimal.nix"
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "${username}";
    startMenuLaunchers = true;

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

    vim
    micro
    # helix
    emacs

    kitty
    wsl-open
    # radioboat
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
