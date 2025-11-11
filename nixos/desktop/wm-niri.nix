{
  pkgs,
  ...
}:
{
  imports = [ ./wm.nix ];

  programs.niri.enable = true;

  # https://github.com/NixOS/nixpkgs/pull/360101
  xdg.portal.config.niri."org.freedesktop.impl.portal.FileChooser" = "gtk";

  environment.systemPackages = with pkgs; [
    niriswitcher
  ];
}
