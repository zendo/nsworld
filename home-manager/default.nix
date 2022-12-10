{ config, lib, nixosConfig, ... }: {

  imports = [
    ./git.nix
    ./cli.nix
    ./zsh.nix
    ./bash.nix
    ./alias.nix
    ./xdg.nix
  ] ++ lib.optionals nixosConfig.services.xserver.enable [
    ./gui.nix
    ./editor.nix
  ] ++ lib.optionals nixosConfig.services.xserver.desktopManager.plasma5.enable [
    ./kderc.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = nixosConfig.system.stateVersion;
}
