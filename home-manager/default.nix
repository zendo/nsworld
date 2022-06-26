{
  config,
  lib,
  nixosConfig,
  ...
}: let
  desktopEnable = nixosConfig.services.xserver.enable;
in {
  imports =
    [
      ./git.nix
      ./cli.nix
      ./bash.nix
      ./zsh.nix
      ./alias.nix
      ./editor.nix
    ]
    ++ lib.optionals desktopEnable [
      ./xdg.nix
      ./gui.nix
    ];

  home.stateVersion = nixosConfig.system.stateVersion;
}
