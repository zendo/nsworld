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
      history = "history 0"; # show whole history
    };
    plugins = [
      # {
      #   name = "fast-syntax-highlighting";
      #   file = "fast-syntax-highlighting.plugin.zsh";
      #   src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      # }
      # {
      #   name = "zsh-nix-shell";
      #   file = "nix-shell.plugin.zsh";
      #   src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      # }
      {
        name = "forgit";
        file = "forgit.plugin.zsh";
        src = "${pkgs.forgit}/share/forgit";
      }
    ];
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

  programs.starship = {
    enable = false;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      # disable "It took xxs"
      # cmd_duration.disabled = true;
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
}
