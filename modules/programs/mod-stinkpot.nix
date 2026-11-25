{
  flake.modules.nixos.programs =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.programs.stinkpot;

      # Upstream ships the shell glue as `stinkpot init <shell>`: it defines the
      # precmd/precmd-style record hook and the Ctrl-R search widget.
      init = shell: ''
        eval "$(${lib.getExe cfg.package} init ${shell})"
      '';
    in
    {
      options.programs.stinkpot = {
        enable = lib.mkEnableOption "stinkpot, a tiny sqlite-backed shell history";

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.stinkpot;
          defaultText = lib.literalExpression "pkgs.stinkpot";
          description = "The stinkpot package to use.";
        };

        enableBashIntegration = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Record every command with its exit code and bind Ctrl-R to the
            stinkpot search widget in interactive bash.
          '';
        };

        enableZshIntegration = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Record every command with its exit code and bind Ctrl-R to the
            stinkpot search widget in interactive zsh.
          '';
        };

        enableFishIntegration = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Record every command with its exit code and bind Ctrl-R to the
            stinkpot search widget in interactive fish.
          '';
        };
      };

      config = lib.mkMerge [
        (lib.mkIf cfg.enable {
          environment.systemPackages = [ cfg.package ];
        })

        (lib.mkIf (cfg.enable && cfg.enableBashIntegration) {
          programs.bash.interactiveShellInit = lib.mkAfter (init "bash");
        })

        (lib.mkIf (cfg.enable && cfg.enableZshIntegration) {
          programs.zsh.interactiveShellInit = lib.mkAfter (init "zsh");
        })

        (lib.mkIf (cfg.enable && cfg.enableFishIntegration) {
          programs.fish.interactiveShellInit = lib.mkAfter ''
            ${lib.getExe cfg.package} init fish | source
          '';
        })
      ];
    };
}
