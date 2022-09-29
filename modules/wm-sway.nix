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

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    # extraSessionCommands = ''
    # '';
    extraPackages = with pkgs; [
      waybar
      autotiling
    ];
  };

  environment.systemPackages = with pkgs; [
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
