{ inputs, config, ... }:
let
  mkHome =
    {
      userName,
      nixpkgs ? inputs.nixpkgs,
      system ? "x86_64-linux",
      stateVersion ? "26.11",
      extraModules ? [ ],
    }:
    inputs.omniflake.flakes.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues config.flake.overlays;
        config.allowUnfree = true;
      };

      modules = [
        config.flake.modules.homeManager.non-nixos
        {
          home.username = "${userName}";
          home.homeDirectory = "/home/${userName}";
          home.stateVersion = stateVersion;
        }
      ]
      ++ extraModules;
    };
in
{
  # imports = [ inputs.omniflake.flakes.home-manager.flakeModules.home-manager ];

  flake.homeConfigurations = {
    iab = mkHome {
      userName = "iab";
      extraModules = [
        config.flake.modules.homeManager.non-nixos-imports
      ];
    };

    guest = mkHome {
      userName = "guest";
      extraModules = [
        config.flake.modules.homeManager.gui
        config.flake.modules.homeManager.zsh
        config.flake.modules.homeManager.files
      ];
    };
  };

  # nix eval --json .#modules.homeManager --apply builtins.attrNames | jq -r '.[]'
  flake.modules.homeManager.non-nixos-imports = {
    imports = with config.flake.modules.homeManager; [
      secrets
      # vicinae
      # ╭──────────────────────────────────────────╮
      # │ PROGRAMS                                 │
      # ╰──────────────────────────────────────────╯
      cli
      # gui
      # rclone
      # ╭──────────────────────────────────────────╮
      # │ SHELL                                    │
      # ╰──────────────────────────────────────────╯
      alias
      # fish
      zsh
      terminal
      # ╭──────────────────────────────────────────╮
      # │ XDG                                      │
      # ╰──────────────────────────────────────────╯
      env
      files
      xdg
    ];
  };

}
