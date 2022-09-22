{
  config,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = false;
    enableBashIntegration = false;
    enableZshIntegration = true;
  };
  xdg.configFile."starship.toml".source = ../dotfiles/starship.toml;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    # prezto = {
    #   enable = true;
    #   prompt.theme = "pure";     # off / pure
    # };
    # oh-my-zsh = {
    #   enable = true;
    #   theme = "simple";         # "" / simple / af-magic
    #   plugins = [ "git" "sudo" ];
    # };
    plugins = [
      # {
      #   name = "zsh-nix-shell";
      #   file = "nix-shell.plugin.zsh";
      #   src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      # }
      # {
      #   name = "forgit";
      #   file = "forgit.plugin.zsh";
      #   src = "${pkgs.forgit}/share/forgit";
      # }
    ];
    history = {
      extended = true; # Save timestamp
      expireDuplicatesFirst = true;
    };
    shellAliases = {
      history = "history 0"; # show whole history
    };
    profileExtra = ''
      # echo -n "\e[?45l"                        # Fix foot terminal dynamic spinner
      setopt no_nomatch                        # bash wildcard
      unsetopt correct                         # Disable AutoCorrect

      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"       # Colored completion (different colors for dirs/files/etc)
    '';
    initExtra = ''
      # Promt pure-promt
      autoload -U promptinit; promptinit
      prompt pure
      zstyle :prompt:pure:prompt:success color green

      # Compatibility bash completion
      autoload -U bashcompinit && bashcompinit
      source ${../overlays/nixos-helper/bCompletions.sh}

      # Compatibility bash word-style
      autoload -U select-word-style
      select-word-style bash

      # Keybindings
      bindkey -e                               # Emacs keybinding
      bindkey  "^[[3~"  delete-char            # Del key
      bindkey  "^[[H"   beginning-of-line      # Home key
      bindkey  "^[[F"   end-of-line            # End key
      bindkey '^[[5~' history-beginning-search-backward # Page up key
      bindkey '^[[6~' history-beginning-search-forward # Page down key
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
