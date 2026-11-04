{
  flake.modules.nixos.mods =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.programs'.bash.blesh;
    in
    {
      options.programs'.bash.blesh = {
        enable = lib.mkEnableOption "ble.sh, a full-featured line editor written in pure Bash";
        enablePurePrompt = lib.mkEnableOption "pure-style prompt for ble.sh";
        settings = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Extra shell code appended after the pure prompt.
            Use this for keybindings, colour schemes and other preferences.
          '';
        };
      };

      config = lib.mkMerge [
        {
          assertions = [
            {
              assertion = !(cfg.enable && config.programs'.bash.flyline.enable);
              message = "Only one of programs'.bash.blesh and programs'.bash.flyline can be enabled.";
            }
          ];
        }

        (lib.mkIf cfg.enable {
          programs.bash.interactiveShellInit = lib.mkMerge [
            (lib.mkOrder 500 ''
              # Source ble.sh before our configuration.
              source ${pkgs.blesh}/share/blesh/ble.sh
            '')
            (lib.mkOrder 1400 (
              lib.optionalString cfg.enablePurePrompt ''
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
