{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = false;
  };

  programs.emacs = {
    enable = true;
    # fix kde two desktop shortcut
    package = (pkgs.emacsPgtk.overrideAttrs
      (oldAttrs: {
        postFixup = ''
        rm $out/share/applications/emacsclient.desktop  '';
      }));
    extraPackages = epkgs: with epkgs; [
      vterm
      emojify
      emacsql-sqlite
      # pdf-tools
      # telega
    ];
  };
  home.file.".doom.d".source = ../emacs/doom;

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
}
