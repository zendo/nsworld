{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { config, pkgs, ... }:
    {
      # nix fmt
      formatter = config.treefmt.build.wrapper;

      treefmt = {
        projectRootFile = "flake.nix";

        ### NIX ###
        # programs.deadnix.enable = true;
        # programs.statix.enable = true;
        programs.nixfmt.enable = true;

        ### SHELL ###
        programs.shfmt.enable = true;
        # programs.shellcheck.enable = true;

        ### HTML/CSS/TS/JSON/YAML/MARKDOWN ###
        programs.prettier.enable = true;
        settings.formatter.prettier.includes = [
          "*.jsonc"
        ];
        settings.formatter.prettier.excludes = [
          "*secrets*"
          "dotfiles/Windows/*"
          "dotfiles/mofa/*"
        ];
        # programs.yamlfmt.enable = true;

        ### TOML ###
        programs.taplo.enable = true;

        ### JUSTFILE ###
        programs.just.enable = true;

        ### LUA ###
        # programs.stylua.enable = true;

        ### PYTHON ###
        programs.black.enable = true;
      };
    };
}
