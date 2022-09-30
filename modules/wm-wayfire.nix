{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  imports = [
    ./wm.nix
  ];

  environment.systemPackages = with pkgs; [
    wayfire
    waybar
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
