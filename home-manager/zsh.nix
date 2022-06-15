{
  config,
  pkgs,
  ...
}: {
  # ~/.inputrc
  programs.readline = {
    enable = true;
    bindings = {
      "\\C-h" = "backward-kill-word";
    };
    extraConfig = ''
      set bell-style none
      set completion-ignore-case on
      # Show all tab-completion options on first <tab>
      set show-all-if-ambiguous on
      $if Bash
          # In bash only, enable "magic space" so that typing space
          # will show completions. i.e. !!_ (where _ is space)
          # will expand !! for you.
          Space: magic-space
      $endif
    '';
  };

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
