{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (lib.hiPrio uutils-coreutils-noprefix)
    tree
    file
    wget
    curl
    micro
    parted
    gptfdisk
    efibootmgr
    # efitools
  ];

  programs.command-not-found = {
    # enable = true;
    dbPath = inputs.nixpkgs + "/programs.sqlite";
  };

  # Load configs from nixos/modules
  programs.zsh.enable = true;

  # Remove perl from activation
  # system.etc.overlay.enable = lib.mkDefault true;

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.05";
  documentation.enable = lib.mkDefault false;
}
