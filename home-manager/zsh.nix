{
  config,
  pkgs,
  ...
}: {
  programs.bash = {
    enable = true;
    # shellAliases = {
    # };
    # bashrcExtra = ''
    # '';
  };

  programs.fish = {
    enable = false;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    prezto = {
      enable = true;
      prompt.theme = "pure";
    };
    shellAliases = {
      history = "history 0";    # show whole history
    };
    initExtra = ''
      echo -n "\e[?45l"                 # Fix foot terminal dynamic spinner
      setopt no_nomatch                 # bash wildcard
      unsetopt correct                  # Disable AutoCorrect
      bindkey -e                        # Emacs keybinding
      bindkey "\e[27;2;13~" accept-line # Shift - enter
      bindkey "\e[27;5;13~" accept-line # Ctrl - enter
      bindkey '^H' backward-kill-word   # Ctrl - backspace
      bindkey "^[[1;3C" forward-word    # Alt - ->
      bindkey "^[[1;3D" backward-word   # Alt - <-
    '';
  };
}
