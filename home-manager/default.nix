{
  config,
  lib,
  nixosConfig,
  ...
}: {
  imports =
    [
      ./git.nix
      ./cli.nix
      ./zsh.nix
      ./bash.nix
      ./alias.nix
      ./xdg.nix
    ]
    ++ lib.optionals nixosConfig.services.xserver.enable [
      ./gui.nix
      ./editor.nix
    ];

  programs.home-manager.enable = true;
  manual.manpages.enable = false;
  home.stateVersion = nixosConfig.system.stateVersion;
}
