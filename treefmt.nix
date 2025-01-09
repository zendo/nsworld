{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {
      # nix fmt
      formatter = config.treefmt.build.wrapper;

      treefmt = {
        projectRootFile = "flake.nix";

        ###############################################
        ## NIX
        ###############################################
        # programs.deadnix.enable = true;
        # programs.statix.enable = true;
        programs.nixfmt.enable = true;
        settings.formatter.nixfmt.excludes = [
          "*hardware-configuration*"
          "lib/*"
        ];

        ###############################################
        ## SHELL
        ###############################################
        programs.shfmt.enable = true;
        # programs.shellcheck.enable = true;

        ###############################################
        ## HTML/CSS/TS/JSON/YAML/MARKDOWN
        ###############################################
        programs.prettier.enable = true;
        settings.formatter.prettier.excludes = [
          "*secrets*"
          "dotfiles/Windows/*"
        ];
        # programs.yamlfmt.enable = true;

        ###############################################
        ## LUA
        ###############################################
        programs.stylua.enable = true;

        ###############################################
        ## PYTHON
        ###############################################
        programs.black.enable = true;
      };
    };
}
