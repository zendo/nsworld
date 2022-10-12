{
  config,
  pkgs,
  ...
}: {
  programs.emacs = {
    enable = true;
    package = #pkgs.emacsPgtkNativeComp; # emacsPgtkNativeComp
    # fix duplicate desktop shortcut in kde
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
      tree-sitter
      # pdf-tools
      # telega
    ];
    extraConfig = ''
      (setq treemacs-python-executable "${pkgs.python3}/bin/python")
      ;; (cl-pushnew (expand-file-name "~/.tree-sitter") tree-sitter-load-path)
    '';
  };

  programs.helix = {
    enable = false;
  };

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

  programs.micro = {
    enable = true;
    settings = {
      autosu = true;
      cursorline = true;
    };
  };

  programs.vscode = {
    enable = true;
  };
}
