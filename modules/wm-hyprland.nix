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

  services.greetd.settings = {
    default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd Hyprland";
    # Autologin
    initial_session = {
      command = "Hyprland";
      user = "${username}";
    };
  };

  # programs.hyprland.enable = true;

  home-manager.users.${username} = {
    inputs,
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.hyprland.homeManagerModules.default];

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        source=./custom.conf
      '';
    };

    home.packages = with pkgs; [
      # hyprpaper # wallpaper
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      }))
    ];
  };
}
