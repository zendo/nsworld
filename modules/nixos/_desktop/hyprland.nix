{ ... }:
{
  imports = [ ./wm.nix ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
}
