{
  flake.modules.nixos.bash =
    { modulesPath, ... }:
    {
      # Functions
      programs.bash.interactiveShellInit = ''
        nix-build-ls() {
          nix build --print-out-paths --no-link "nixpkgs#$1" | xargs yazi
        }
      '';

      programs'.bash.flyline = {
        # enable = true;
        enablePurePrompt = true;
        settings = ''
          # flyline suggestions --auto-suggest false

          flyline mouse --mode disabled
          flyline key bind Right inlineSuggestionAvailable+cursorAtEnd+!tabCompletionMultiColAvailable=inlineSuggestionAcceptOneWord
          flyline key bind Ctrl+f inlineSuggestionAvailable+cursorAtEnd+!tabCompletionMultiColAvailable=inlineSuggestionAccept

          # Agent mode
          flyline set-agent-mode \
            --system-prompt "Be concise. Answer ONLY with a raw JSON array of at most 3 items with objects containing: command and description. Do not wrap in markdown code blocks. Command will be a Bash command." \
            --trigger-prefix ': ' \
            --command 'pi --mode text'
        '';
      };

      programs'.bash.blesh = {
        enable = true;
        enablePurePrompt = true;
        settings = ''
          # Enable alias command completion
          shopt -s progcomp_alias
          bleopt prompt_eol_mark=' '
          bleopt color_scheme=rosepine_moon

          # ble.sh binds these to copy-backward-sword; restore readline's
          # backward-kill-word (Alt+Backspace / Alt+Ctrl+H)
          ble-bind -f 'M-C-?' kill-backward-cword # Alt+Backspace (ESC DEL)
          ble-bind -f 'M-DEL' kill-backward-cword # Alt+Backspace (DEL)
          ble-bind -f 'M-BS'  kill-backward-cword # Alt+Backspace (ESC BS)
          ble-bind -f 'M-C-h' kill-backward-cword # Alt+Ctrl+H (ESC Ctrl+H)

          # Right inserts one word of the auto-complete suggestion (like Tab),
          # instead of the whole suggested command.
          # Use insert-cword instead of insert-word for finer word boundaries.
          ble-bind -m auto_complete -f right 'auto_complete/@end insert-word'
        '';
      };

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
