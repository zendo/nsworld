{ inputs, lib, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    {
      inputs',
      pkgs,
      config,
      ...
    }:
    {
      # nix fmt
      formatter = config.treefmt.build.wrapper;

      treefmt = {
        projectRootFile = "flake.nix";

        # nix
        # programs.deadnix.enable = true;
        # programs.statix.enable = true;
        programs.nixfmt.enable = true;
        settings.formatter.nixfmt.excludes = [
          "*hardware-configuration*"
          "lib/*"
        ];

        # shell
        programs.shfmt.enable = true;
        # programs.shellcheck.enable = true;

        # html/css/json/ts/yaml
        programs.prettier.enable = true;
        settings.formatter.prettier.excludes = [
          "*secrets*"
        ];
        # programs.yamlfmt.enable = true;

        # lua
        programs.stylua.enable = true;

        # python
        programs.black.enable = true;
      };
    };
}
