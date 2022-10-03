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
    default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd sway";
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

  home-manager.users.${username} = {
    pkgs,
    config,
    ...
  }: {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = null;
      extraConfig = ''
        include ${../dotfiles/sway/custom.conf}
        exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      '';
      # extraSessionCommands = ''
      #   export XDG_CURRENT_DESKTOP="sway"
      # '';
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
      autotiling-rs
    ];
  };
}
