{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.sessionPath = [
    "${../../dotfiles/bin}"
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient -c -a emacs";
    VISUAL = "micro";
    NIXOS_OZONE_WL = lib.mkDefault 1; # Electron wayland native
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  # Cursor Theme
  # home.pointerCursor = {
  #   name = "Vanilla-DMZ-AA";
  #   package = pkgs.vanilla-dmz;
  #   size = 128;
  # };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    autostart = {
      enable = true;
      readOnly = true;
      entries = [
        # "${pkgs.goodvibes}/share/applications/io.gitlab.Goodvibes.desktop"
      ];
    };

    # dataFile = {
    #   # Fix qt tiny cursor on gnome
    #   "icons/default/index.theme".text = ''
    #     [icon theme]
    #     Inherits=Adwaita
    #   '';
    # };

    desktopEntries = {
      # code = {
      #   name = "Visual Studio Code";
      #   icon = "vscode";
      #   exec = "env NIXOS_OZONE_WL= code";
      # };
      # doom-emacs = {
      #   name = "Doom Emacs";
      #   icon = "${../dotfiles/emacs/doom-emacs.svg}";
      #   exec = ''sh -c "emacs --init-directory ${config.home.homeDirectory}/.config/doom-emacs"'';
      # };
    };
  };
}
