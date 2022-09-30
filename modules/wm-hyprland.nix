{
  config,
  pkgs,
  lib,
  inputs,
  username,
  ...
}: {
  imports = [
    ./wm.nix
    inputs.hyprland.nixosModules.default
  ];

  programs.hyprland.enable = true;

  security.pam.services.swaylock = {};

  environment.systemPackages = with pkgs; [
    # hyprpaper # wallpaper
    # hyprpicker # color picker
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    }))
  ];

  home-manager.users.${username} = {
    pkgs,
    config,
    ...
  }: {
    home.packages = with pkgs; [
    ];
  };
}
