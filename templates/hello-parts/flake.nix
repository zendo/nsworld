{
  description = "Hello parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:/hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        systems = lib.systems.flakeExposed;
        perSystem =
          {
            config,
            self',
            inputs',
            pkgs,
            system,
            ...
          }:
          {
            # nix run
            packages = {
              hello = pkgs.callPackage ./default.nix { };
              default = config.packages.hello;
            };

            # nix develop
            devShells.default = pkgs.mkShell {
              buildInputs = with pkgs; [
                cargo
                rustc
              ];
            };

            # nix fmt
            formatter = pkgs.alejandra;
          };
      }
    );
}
