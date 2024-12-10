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
  };

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # GUI
        foot
        kitty
      ];
    };

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    wget
    wslu
    wsl-open
  ];

  programs = {
    zsh.enable = true;
    command-not-found.enable = false;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  documentation = {
    enable = lib.mkDefault false;
    man.enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
  };

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.05";
}
