{ config, pkgs, ... }:

{
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
    extraPackages = epkgs: with epkgs.melpaPackages; [
      vterm
      # telega
      # pdf-tools
    ];
  };
  # home.file.".emacs.d/init.el".source = ./emacs/init.el;
  # home.file.".emacs.d/early-init.el".source = ./emacs/early-init.el;
  # home.file.".emacs.d/lisp".source = ./emacs/lisp;

  programs.vim = {
    enable = true;
    # plugins = with pkgs.vimPlugins; [
    #   vim-nix
    #   vim-lsp
    #   vim-markdown
    #   rust-vim
    #   fzf-vim
    #   vim-colorschemes
    # ];
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

  programs.gnome-terminal = {
    enable = false;
    showMenubar = false;
    profile = {
      "5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
        default = true;
        visibleName = "Tomorrow Night";
        cursorShape = "ibeam";
        customCommand = "/usr/bin/env zsh";
        # font = "DejaVu Sans Mono 11";
        font = "Hack 11";
        # showScrollbar = false;
        # transparencyPercent = 70;
        audibleBell = false;
        colors = {
          foregroundColor = "rgb(197,200,198)";
          palette = [
            "rgb(0,0,0)"
            "rgb(145,34,38)"
            "rgb(119,137,0)"
            "rgb(174,123,0)"
            "rgb(103,123,192)"
            "rgb(104,42,155)"
            "rgb(43,102,81)"
            "rgb(146,149,147)"
            "rgb(102,102,102)"
            "rgb(204,102,102)"
            "rgb(181,189,104)"
            "rgb(240,198,116)"
            "rgb(140,152,191)"
            "rgb(178,148,187)"
            "rgb(138,190,183)"
            "rgb(236,235,236)"
          ];
          boldColor = "rgb(138,186,183)";
          backgroundColor = "rgb(29,31,33)";
        };
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      # env.TERM = "xterm-256color";
      shell.program = "${pkgs.zsh}/bin/zsh";
      background_opacity = 0.85;
      window.dimensions = {
        columns = 90;
        lines = 30;
      };
      font = {
        size = 11;
        normal = { family = "JetBrains Mono"; };
      };
      key_bindings = [
        { key = "C"; mods = "Control"; action = "Copy"; }
        { key = "V"; mods = "Control"; action = "Paste"; }
        { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
        { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Equals"; mods = "Control"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Plus"; mods = "Control"; action = "IncreaseFontSize"; }
      ];
    };
  };

  programs.tmux = {
    enable = false;
    extraConfig = ''
      # Set the prefix.
      # set -g prefix M-a

      # Close the current session.
      bind -n M-q kill-session

      # Close the current pane.
      bind -n M-w kill-pane
    '';
  };

  # cursor
  # xsession.pointerCursor = {
  #   name = "Vanilla-DMZ";
  #   package = pkgs.vanilla-dmz;
  #   size = 128;
  # };

}
