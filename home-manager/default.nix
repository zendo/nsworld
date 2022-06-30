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
      ./bash.nix
      ./zsh.nix
      ./alias.nix
    ]
    ++ lib.optionals nixosConfig.services.xserver.enable [
      ./xdg.nix
      ./gui.nix
      ./editor.nix
    ];

  manual.manpages.enable = false;

  home.stateVersion = nixosConfig.system.stateVersion;
}
