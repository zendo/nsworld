{
  flake.modules.homeManager.bash =
    { config, pkgs, ... }:
    {
      programs.bash = {
        enable = true;
        historyFile = "${config.xdg.dataHome}/bash/history";
        bashrcExtra = ''
          enable -f ${pkgs.flyline}/lib/libflyline.so flyline

          # Pure Prompt Style
          # flyline create-prompt-widget custom --name SS_GIT \
          #   --command "bash -c 'starship module git_branch && starship module git_status'" \
          #   --placeholder 0
          # export PS1='\n\[\e[36m\]\w\[\e[0m\] SS_GIT\n\[\e[35m\]❯ \[\e[0m\]'
          # flyline create-prompt-widget last-command-duration
          # export RPS1='\[\e[33m\]FLYLINE_LAST_COMMAND_DURATION\[\e[0m\]'
        '';
      };

      # ~/.inputrc
      programs.readline = {
        enable = true;
        bindings = {
          "\\C-h" = "backward-kill-word";
        };
        variables = {
          bell-style = "none";
          bind-tty-special-chars = true;
          blink-matching-paren = true;
          colored-completion-prefix = true;
          colored-stats = true;
          # completion-display-width = 0;
          completion-ignore-case = true;
          enable-bracketed-paste = true;
          match-hidden-files = true;
          show-all-if-ambiguous = true;
          mark-symlinked-directories = true;
        };
      };
    };
}
