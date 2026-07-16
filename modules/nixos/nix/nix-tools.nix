{
  flake.modules.homeManager.nix-tools =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        # alejandra
        nixfmt
        # lorri
        # cachix
        # comma # ,
        nix-tree
        nurl
        # nix-prefetch
        # nix-template
        dix # diff
        nix-output-monitor
        nix-search-tv
        nix-auth
        # hydra-check

        (writeScriptBin "nsearch" ''nix search nixpkgs "$@"'')
        (writeScriptBin "nsa" (builtins.readFile "${nix-search-tv.src}/nixpkgs.sh"))
        (writeScriptBin "pr-check" ''
          curl -s "https://nixpkgs.molybdenum.software/api/v2/landings/"$@"" | jq .
        '')
      ];

      programs = {
        nh = {
          enable = true;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 3";
          flake = "${config.home.homeDirectory}/nsworld";
        };

        nix-index = {
          # enable = true;
        };

        # Causes the `motd` not working
        nix-your-shell = {
          # enable = true;
        };

        devenv = {
          # enable = true;
        };

        # echo "use flake" >> .envrc && direnv allow
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };
    };
}
