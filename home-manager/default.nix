{
  config,
  lib,
  nixosConfig,
  ...
}: let
  needsGui = nixosConfig.services.xserver.enable;
in {
  imports =
    [
      ./git.nix
      ./cli.nix
      ./alias.nix
      ./zsh.nix
      ./bash.nix
      ./xdg.nix
      ./editor.nix
    ]
    ++ lib.optionals needsGui [./gui.nix];
}
