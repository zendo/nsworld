{ inputs, lib, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { inputs', pkgs, ... }:
    {
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
      };
    };
}
