{
  config,
  pkgs,
  ...
}: {
  programs.emacs = {
    enable = true;
    # fix kde two desktop shortcut
    package =
      pkgs.emacsPgtk.overrideAttrs
      (oldAttrs: {
        postFixup = ''
          rm $out/share/applications/emacsclient.desktop  '';
      });
    extraPackages = epkgs:
      with epkgs; [
        vterm
        emojify
        emacsql-sqlite
        # pdf-tools
        # telega
      ];
  };
  home.file.".doom.d".source = ../emacs/doom;

  programs.helix = {
    enable = true;
  };
  xdg.configFile."helix".source = ../dotfiles/helix;

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

  programs.vscode = {
    enable = false;
  };
}
