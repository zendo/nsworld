{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [ pure-prompt ];

  programs.fish = {
    enable = false;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      # {
      #   name = "zsh-nix-shell";
      #   file = "nix-shell.plugin.zsh";
      #   src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      # }
      # {
      #   name = "minimal";
      #   file = "minimal.zsh";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "subnixr";
      #     repo = "minimal";
      #     rev = "6588a399744f34194a25988b4c159cb8b8c67e27";
      #     hash = "sha256-r5AIk7TzXQ5x+mXRA6isWCn0FvmICeFR36k5Kq4s+Yk=";
      #   };
      # }
    ];
    history = {
      extended = true; # Save timestamp
      expireDuplicatesFirst = true;
    };
    shellAliases = {
      history = "history 0"; # show whole history
    };
    initExtra = ''
      # setopt no_nomatch # Compatible bash wildcard
      unsetopt correct  # Disable AutoCorrect

      ## Promt theme
      # autoload -U promptinit; promptinit
      # PURE_PROMPT_SYMBOL=›
      # PURE_PROMPT_VICMD_SYMBOL=‹
      # prompt pure

      ## Other themes
      # source minimal.zsh
      # source ${../dotfiles/zsh/oxide.zsh-theme}

      # Compatibility bash completion
      autoload -U bashcompinit && bashcompinit
      source ${../overlays/pkgs/by-name/ns-cli/ns.bash}

      # Using nix-shell on zsh
      ${lib.getExe pkgs.any-nix-shell} zsh --info-right | source /dev/stdin

      # Completions
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive tab completion
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}" # Colored completion (different colors for dirs/files/etc)
      zstyle ':completion:*' menu select                        # Hit 'TAB' to select

      # Bash-like navigation between words
      autoload -U select-word-style
      select-word-style bash

      # Keybindings
      bindkey -e                               # Emacs keybinding
      bindkey  "^[[3~"  delete-char            # Del key
      bindkey  "^[[H"   beginning-of-line      # Home key
      bindkey  "^[[F"   end-of-line            # End key
      bindkey '^[[5~' history-beginning-search-backward # Page up key
      bindkey '^[[6~' history-beginning-search-forward  # Page down key
      bindkey "\e[27;2;13~" accept-line        # Shift - enter
      bindkey "\e[27;5;13~" accept-line        # Ctrl - enter
      bindkey '^H' backward-kill-word          # Ctrl - backspace
      bindkey "^[[1;5C" forward-word           # Ctrl - ->
      bindkey "^[[1;5D" backward-word          # Ctrl - <-
      bindkey "^[[1;3C" forward-word           # Alt - ->
      bindkey "^[[1;3D" backward-word          # Alt - <-
    '';
  };
}
