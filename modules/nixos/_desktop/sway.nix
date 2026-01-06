{ pkgs, ... }:
{
  imports = [ ./wm.nix ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [
      pkgs.autotiling-rs
    ];
  };
}
