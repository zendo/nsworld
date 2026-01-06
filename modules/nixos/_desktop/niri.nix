{ ... }:
{
  imports = [ ./wm.nix ];

  programs.niri.enable = true;

  services.displayManager.dms-greeter.compositor.name = "niri";
}
