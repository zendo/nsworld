{
  flake.modules.nixos.mods =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.programs'.bash.flyline;
    in
    {
      options.programs'.bash.flyline = {
        enable = lib.mkEnableOption "flyline, a modern Bash line editor";
        enablePurePrompt = lib.mkEnableOption "pure-style prompt for flyline";
        settings = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Extra shell code appended after the pure prompt.
            Use this for keybindings, mouse mode, agent mode and other preferences.
          '';
        };
      };

      config = lib.mkMerge [
        {
          assertions = [
            {
              assertion = !(cfg.enable && config.programs'.bash.blesh.enable);
              message = "Only one of programs'.bash.blesh and programs'.bash.flyline can be enabled.";
            }
          ];
        }

        (lib.mkIf cfg.enable {
          programs.bash.interactiveShellInit = lib.mkMerge [
            (lib.mkOrder 500 ''
              enable -f ${pkgs.flyline}/lib/libflyline.so flyline
            '')
            (lib.mkOrder 1400 (
              lib.optionalString cfg.enablePurePrompt ''
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

                # pure 提示默认不含 user@host（本地终端不需要）。SSH 会话里补上，
                # 与 mods/blesh.nix 保持同样的行为。
                __flyline_pure_host=
                if [[ -n ''${SSH_CONNECTION-} ]]; then
                  __flyline_pure_host='\e[32m\u@\h\e[0m '
                fi

                PS1='\n'$__flyline_pure_host'\e[34m\w\e[0m$(__flyline_pure_git) \e[33mFLYLINE_LAST_COMMAND_DURATION\e[0m\n$(__flyline_pure_char) '
              ''
            ))
            (lib.mkOrder 1500 cfg.settings)
          ];
        })

        (lib.mkIf (cfg.enable && cfg.enablePurePrompt) {
          # NixOS's default prompt would otherwise overwrite our PS1.
          programs.bash.promptInit = "";
        })
      ];
    };
}
