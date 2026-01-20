{ pkgs, ... }:
{
  # Cursor Theme
  # home.pointerCursor = {
  #   name = "Vanilla-DMZ-AA";
  #   package = pkgs.vanilla-dmz;
  #   size = 128;
  # };

  # https://github.com/search?q=repo%3Anix-community%2Fhome-manager%20%20preferXdgDirectories&type=code
  home.preferXdgDirectories = true;

  xdg = {
    enable = true;

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
