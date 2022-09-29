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

  services.xserver.displayManager = {
    # sddm.enable = true;
    # lightdm.enable = true;
    # defaultSession = "wayfire";
  };

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
