{ config, pkgs, ... }:
{
  # home.packages = with pkgs; [
  #   pure-prompt
  # ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      extended = true; # timestamp
      expireDuplicatesFirst = true;
    };
    shellAliases = {
      history = "history 0"; # show whole history
    };
    # loginExtra = ''
    #   cd ~/nsworld
    # '';
    initContent = ''
      unsetopt correct  # Disable AutoCorrect

      # Theme
      # autoload -U promptinit; promptinit
      # prompt pure

      # Completions
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive tab completion
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}" # Colored completion (different colors for dirs/files/etc)
      zstyle ':completion:*' menu select                        # Hit 'TAB' to select

      # Bash-like navigation between words
      autoload -U select-word-style
      select-word-style bash

      # Keybindings
      bindkey -e                                        # Emacs keybinding
      bindkey "^[[3~" delete-char                       # Del key
      bindkey "^[[H" beginning-of-line                  # Home key
      bindkey "^[[F" end-of-line                        # End key
      bindkey "^[[5~" history-beginning-search-backward # Page up key
      bindkey "^[[6~" history-beginning-search-forward  # Page down key
      bindkey "\e[27;2;13~" accept-line                 # Shift - enter
      bindkey "\e[27;5;13~" accept-line                 # Ctrl  - enter
      bindkey "^H" backward-kill-word                   # Ctrl  - backspace
      bindkey "^[[1;5C" forward-word                    # Ctrl  - →
      bindkey "^[[1;5D" backward-word                   # Ctrl  - ←
      bindkey "^[[1;3C" forward-word                    # Alt   - →
      bindkey "^[[1;3D" backward-word                   # Alt   - ←
      bindkey '\e[1;3A' beginning-of-line               # ALT   - ↑
      bindkey '\e[1;3B' end-of-line                     # ALT   - ↓
    '';
  };
}
