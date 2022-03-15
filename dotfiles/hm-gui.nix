{ config, pkgs, ... }:

{
  xdg.desktopEntries.spotify = {
    name = "Spotify";
    genericName = "Music Player";
    icon = "spotify-client";
    exec = "spotify %U --force-device-scale-factor=2";
    terminal = false;
    categories = [ "Application" "Music" ];
  };

  programs.vscode = {
    enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtk;
    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.emacsql-sqlite
      # epkgs.telega
    ];
  };
  # home.file.".doom.d".source = ../emacs/doom;
  # centaur
  # home.file.".emacs.d/custom.el".source = ../emacs/centaur/custom.el;
  # home.file.".emacs.d/custom-post.el".source = ../emacs/centaur/custom-post.el;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-lsp
      vim-markdown
    ];
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "onedark";
      # editor.file-picker.hidden = true;
      lsp.display-messages = true;
      keys.normal = {
        space.space = "file_picker";
        space.q = ":q";
      };
    };
  };

  programs.chromium = {
    enable = false;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  # fix tiny cursor in qt-apps @gnome
  xsession.pointerCursor = {
    name = "Vanilla-DMZ-AA";
    package = pkgs.vanilla-dmz;
    size = 128;
  };

}
