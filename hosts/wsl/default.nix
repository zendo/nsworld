/*
  wsl --version 2 --import NixOS $env:USERPROFILE\NixOS\ nixos-wsl.tar.gz
  wsl --unregister nixos
*/
{
  lib,
  pkgs,
  username,
  ...
}:
{
  wsl = {
    enable = true;
    defaultUser = "${username}";
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    wget
    nix-bash-completions
    wslu
    wsl-open

    # GUI
    foot
    kitty
    # goodvibes
    # emacs29-pgtk
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # zsh
  programs.zsh.enable = true;
  # users.defaultUserShell = pkgs.zsh;

  programs.command-not-found.enable = false;

  documentation = {
    enable = lib.mkDefault false;
    man.enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
  };

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "24.05";
}
