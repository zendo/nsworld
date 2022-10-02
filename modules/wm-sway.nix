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

  services.greetd.settings = {
    default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
    # Autologin
    initial_session = {
      command = "sway";
      user = "${username}";
    };
  };

  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true; # so that gtk works properly
  #   # extraSessionCommands = ''
  #   # '';
  # };

  # Needs when use sway@hm
  security.pam.services.swaylock = {};
  programs = {
    dconf.enable = true;
    xwayland.enable = true;
  };

  home-manager.users.${username} = {
    pkgs,
    config,
    ...
  }: {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraConfig = ''
        include ${../dotfiles/sway/custom.conf}
        exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      '';
      config = null;
      # config = {
      #   modifier = "Mod4";
      #   terminal = "systemd-run-app foot";
      #   startup = [
      #     {command = "systemd-run-app foot";}
      #     {command = "systemd-run-app firefox";}
      #     {command = "systemd-run-app telegram-desktop";}
      #     {command = "systemd-run-app thunderbird";}
      #   ];
      # };
    };

    home.packages = with pkgs; [
      waybar
      autotiling
    ];
  };
}
