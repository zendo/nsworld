{
  config,
  pkgs,
  ...
}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtkNativeComp; # emacsPgtkNativeComp
    # fix duplicate desktop shortcut in kde
    # pkgs.emacsPgtk.overrideAttrs
    # (oldAttrs: {
    #   postFixup = ''
    #     rm $out/share/applications/emacsclient.desktop  '';
    # });
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
      neogit
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
    extensions =  with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-zh-hans
      jnoortheen.nix-ide
      kamadorueda.alejandra
      editorconfig.editorconfig
      file-icons.file-icons
      golang.go
      mattn.lisp
    ];
    userSettings = {
      "files.autoSave" = "onFocusChange";
      "editor.fontSize" = 13;
      "editor.fontFamily" = "'JetBrains Mono', 'Hack', 'Droid Sans Mono', monospace, 'Droid Sans Fallback'";
      "update.mode" = "none";
      # "workbench.colorTheme" = "Monokai";
      # "workbench.commandPalette.preserveInput" = true;
      # "workbench.editor.enablePreviewFromCodeNavigation" = true;
      # "workbench.iconTheme" = "vscode-icons";
    };
  };
}
