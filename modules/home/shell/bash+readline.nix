{
  flake.modules.nixos.bash = { modulesPath, pkgs, ... }: {
    programs.bash.interactiveShellInit = ''
      # Flyline Setup
      enable -f ${pkgs.flyline}/lib/libflyline.so flyline
      flyline mouse --mode disabled
      flyline suggestions --auto-suggest false
      flyline key bind Ctrl+f inlineSuggestionAvailable+cursorAtEnd+!tabCompletionMultiColAvailable=inlineSuggestionAccept

      # Flyline Pure Prompt Style
      # flyline create-prompt-widget custom --name SS_GIT \
      #   --command "bash -c 'starship module git_branch && starship module git_status'" \
      #   --placeholder 0
      # export PS1='\n\[\e[36m\]\w\[\e[0m\] SS_GIT\n\[\e[35m\]❯ \[\e[0m\]'
      # flyline create-prompt-widget last-command-duration
      # export RPS1='\[\e[33m\]FLYLINE_LAST_COMMAND_DURATION\[\e[0m\]'

      # Flyline Agent
      flyline set-agent-mode \
        --system-prompt "Be concise. Answer ONLY with a raw JSON array of at most 3 items with objects containing: command and description. Do not wrap in markdown code blocks. Command will be a Bash command." \
        --trigger-prefix ': ' \
        --command 'pi --mode text'
    '';

    # Only work on Vanilla Bash
    environment.etc.inputrc.text = ''
      ${builtins.readFile "${modulesPath}/programs/bash/inputrc"}
      set bind-tty-special-chars on
      set blink-matching-paren on
      set colored-completion-prefix on
      set colored-stats on
      set completion-ignore-case on
      set enable-bracketed-paste on
      set mark-symlinked-directories on
      set match-hidden-files on
      set show-all-if-ambiguous on
      "\C-h": backward-kill-word
    '';
  };
}
