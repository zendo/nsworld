{
  flake.modules.nixos.bash =
    { modulesPath, pkgs, ... }:
    let
      flylineCfg = ''
        enable -f ${pkgs.flyline}/lib/libflyline.so flyline

        # flyline suggestions --auto-suggest false

        flyline mouse --mode disabled
        flyline key bind Right inlineSuggestionAvailable+cursorAtEnd+!tabCompletionMultiColAvailable=inlineSuggestionAcceptOneWord
        flyline key bind Ctrl+f inlineSuggestionAvailable+cursorAtEnd+!tabCompletionMultiColAvailable=inlineSuggestionAccept

        # Pure-style prompt
        __flyline_pure_status=0
        __flyline_pure_precmd() { __flyline_pure_status=$?; }
        if [[ ''${PROMPT_COMMAND@a} == *a* ]]; then
          PROMPT_COMMAND=(__flyline_pure_precmd "''${PROMPT_COMMAND[@]}")
        else
          PROMPT_COMMAND="__flyline_pure_precmd''${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
        fi

        __flyline_pure_git() {
          local branch dirty
          branch=$(git branch --show-current 2>/dev/null) || return 0
          [[ $branch ]] || return 0
          dirty=$(git status --porcelain --ignore-submodules=untracked 2>/dev/null)
          local gray=$'\e[90m' cyan=$'\e[36m' red=$'\e[31m' reset=$'\e[m'
          if [[ $dirty ]]; then
            printf ' %sgit:(%s%s%s) %s✘%s' "$gray" "$cyan" "$branch" "$gray" "$red" "$reset"
          else
            printf ' %sgit:(%s%s%s)%s' "$gray" "$cyan" "$branch" "$gray" "$reset"
          fi
        }

        __flyline_pure_char() {
          if ((__flyline_pure_status)); then
            printf '\e[31m❯\e[m'
          else
            printf '\e[35m❯\e[m'
          fi
        }

        flyline create-prompt-widget last-command-duration
        PS1='\n\e[34m\w\e[0m$(__flyline_pure_git) \e[33mFLYLINE_LAST_COMMAND_DURATION\e[0m\n$(__flyline_pure_char) '

        # Agent mode
        flyline set-agent-mode \
          --system-prompt "Be concise. Answer ONLY with a raw JSON array of at most 3 items with objects containing: command and description. Do not wrap in markdown code blocks. Command will be a Bash command." \
          --trigger-prefix ': ' \
          --command 'pi --mode text'
      '';

      bleshCfg = ''
        source ${pkgs.blesh}/share/blesh/ble.sh

        # Enable alias command completion
        shopt -s progcomp_alias

        # ble.sh binds these to copy-backward-sword; restore readline's
        # backward-kill-word (Alt+Backspace / Alt+Ctrl+H)
        ble-bind -f 'M-C-?' kill-backward-cword # Alt+Backspace (ESC DEL)
        ble-bind -f 'M-DEL' kill-backward-cword # Alt+Backspace (DEL)
        ble-bind -f 'M-BS'  kill-backward-cword # Alt+Backspace (ESC BS)
        ble-bind -f 'M-C-h' kill-backward-cword # Alt+Ctrl+H (ESC Ctrl+H)

        bleopt color_scheme=rosepine_moon

        bleopt prompt_eol_mark=' '

        # Pure-style prompt
        ble-import contrib/prompt-git
        ble-import contrib/prompt-elapsed

        # Exit status of the last command, captured before the prompt is built
        pure_status=0
        function pure/precmd { pure_status=$?; }
        blehook PRECMD=pure/precmd

        # Git branch + dirty marker (`main*`): gray branch, pink `*` when dirty
        function ble/prompt/backslash:pure-git {
          local "''${_ble_contrib_prompt_git_vars[@]/%/=}" dirty_mark
          ble/contrib/prompt-git/initialize || return 0
          ble/contrib/prompt-git/update-head-information
          [[ $branch ]] || return 0
          ble/contrib/prompt-git/get-dirty-mark
          local gray=$'\e[38;5;242m' pink=$'\e[38;5;218m' reset=$'\e[m'
          [[ $dirty_mark ]] && dirty_mark="''${pink}*"
          ble/prompt/print " ''${gray}''${branch}''${dirty_mark}''${reset}"
        }

        # Elapsed time of the last command (from contrib/prompt-elapsed),
        # only shown when it took > 5s
        function ble/prompt/backslash:pure-elapsed {
          ((_ble_exec_time_ata > 5000000)) || return 1
          ble/prompt/print ' '
          ble/prompt/backslash:contrib/elapsed
        }

        # ❯ in magenta, or red if the previous command failed
        function ble/prompt/backslash:pure-prompt {
          if ((pure_status)); then
            ble/prompt/print $'\e[31m❯\e[m'
          else
            ble/prompt/print $'\e[35m❯\e[m'
          fi
        }

        PS1='\n\g{fg=4}\w\g{}\q{pure-git}\g{fg=3}\q{pure-elapsed}\g{}\n\q{pure-prompt} '
      '';
    in
    {
      # NixOS's default prompt would otherwise overwrite the pure-style PS1
      programs.bash.promptInit = "";

      programs.bash.interactiveShellInit = ''
        ${flylineCfg}

        # Functions
        nix-build-ls() {
          nix build --print-out-paths --no-link "nixpkgs#$1" | xargs yazi
        }
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
