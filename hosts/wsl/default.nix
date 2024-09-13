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
  system.stateVersion = "24.11";
}
