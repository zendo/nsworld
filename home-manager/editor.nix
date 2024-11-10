{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc
    cmake
    gnumake
    python3
    # nil
    nixd
  ];

  programs.pandoc = {
    enable = false;
  };

  ###############################################
  ##  EMACS
  ###############################################
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
    extraPackages =
      epkgs: with epkgs; [
        jinx
        vterm
        emojify
        emacsql-sqlite
        # lsp-bridge
        # pdf-tools
        # telega
        (treesit-grammars.with-grammars (p: builtins.attrValues p))
      ];
    extraConfig = ''
      (display-time-mode 1)
    '';
  };

  ###############################################
  ##  VSCODE
  ###############################################
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-zh-hans
      jnoortheen.nix-ide
      editorconfig.editorconfig
      file-icons.file-icons
      golang.go
      mattn.lisp
      eamodio.gitlens
      ms-vscode.cmake-tools
    ];
    userSettings = {
      "files.autoSave" = "onFocusChange";
      "editor.fontSize" = 13;
      "editor.fontFamily" = "'JetBrains Mono', 'Hack', 'Droid Sans Mono', monospace, 'Droid Sans Fallback'";
      "update.mode" = "none";
      "nix.formatterPath" = "nixfmt";
      # "workbench.colorTheme" = "Monokai";
      # "workbench.commandPalette.preserveInput" = true;
      # "workbench.editor.enablePreviewFromCodeNavigation" = true;
      # "workbench.iconTheme" = "vscode-icons";
    };
    # keybindings = [
    #   {
    #     key = "ctrl+m";
    #     command = "editor.action.clipboardCopyAction";
    #     when = "textInputFocus";
    #   }
    # ];
  };

  ###############################################
  ##  ZED-EDITOR
  ###############################################
  programs.zed-editor = {
    # enable = true;
    extensions = [
      "nix"
      "xy-zed" # a gorgeous dark theme
    ];
    userSettings = {
      features = {
        copilot = false;
      };
      telemetry = {
        metrics = false;
      };
      vim_mode = false;
      ui_font_size = 16;
      buffer_font_size = 16;
    };
  };

  ###############################################
  ##  TUI
  ###############################################
  programs.helix = {
    enable = true;
  };

  programs.neovim = {
    # enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      neogit
      fzf-vim
      vim-nix
      vim-lsp
      vim-markdown
      editorconfig-vim
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
    ];
    extraPackages = with pkgs; [ lua-language-server ];
    # extraConfig = ''
    # '';
  };
}
