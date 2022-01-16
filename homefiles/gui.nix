{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
  };
  xdg.configFile."alacritty/alacritty.yml".source = ../others/alacritty.yml;

  programs.vscode = {
    enable = true;
    # extensions = with pkgs.vscode-extensions; [
    #   ms-ceintl.vscode-language-pack-zh-hans
    #   mattn.lisp
    #   jnoortheen.nix-ide
    # ];
    # userSettings = {
    #   "editor.formatOnSave" = false;
    #   "editor.minimap.enabled" = false;
    # };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtk;
    extraPackages = epkgs: [
      epkgs.vterm
      # epkgs.telega
    ];
  };
#   home.file.".doom.d".source = ../emacs/doom;
  # home.file.".emacs.d/custom.el".source = ../emacs/centaur/custom.el;
  # home.file.".emacs.d/custom-post.el".source = ../emacs/centaur/custom-post.el;
  # home.file.".emacs.d/init.el".source = ../emacs/init.el;
  # home.file.".emacs.d/early-init.el".source = ../emacs/early-init.el;
  # home.file.".emacs.d/lisp".source = ../emacs/lisp;

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

  # cursor
  # xsession.pointerCursor = {
  #   name = "Vanilla-DMZ";
  #   package = pkgs.vanilla-dmz;
  #   size = 128;
  # };

}
