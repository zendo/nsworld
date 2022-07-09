{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    prezto = {
      enable = true;
      prompt.theme = "pure";
    };
    # oh-my-zsh = {
    #   enable = true;
    #   theme = "simple";
    #   plugins = ["git" ];
    # };
    shellAliases = {
      history = "history 0"; # show whole history
    };
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
    initExtra = ''
      echo -n "\e[?45l"                 # Fix foot terminal dynamic spinner
      setopt no_nomatch                 # bash wildcard
      unsetopt correct                  # Disable AutoCorrect

      autoload -U bashcompinit && bashcompinit # compatibility bash completion
      source ${../overlays/nixos-helper/bCompletions.sh}

      bindkey -e                        # Emacs keybinding
      bindkey "\e[27;2;13~" accept-line # Shift - enter
      bindkey "\e[27;5;13~" accept-line # Ctrl - enter
      bindkey '^H' backward-kill-word   # Ctrl - backspace
      bindkey "^[[1;3C" forward-word    # Alt - ->
      bindkey "^[[1;3D" backward-word   # Alt - <-
    '';
  };
}
