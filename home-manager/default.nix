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
      ./editor.nix
    ]
    ++ lib.optionals nixosConfig.services.xserver.enable [
      ./xdg.nix
      ./gui.nix
    ];

  home.stateVersion = nixosConfig.system.stateVersion;
}
