{
  flake.modules.nixos.fish = {
    documentation.man.cache.enable = false;
    programs.fish.enable = true;
  };

  flake.modules.homeManager.fish =
    { pkgs, ... }:
    {
      programs.man.generateCaches = false;

      # https://carapace.sh/
      programs.carapace = {
        enable = true;
        ignoreCase = true;
        enableBashIntegration = false;
      };

      programs.fish = {
        enable = true;
        # generateCompletions = true;
        plugins = [
          # {
          #   name = "pure";
          #   src = pkgs.fishPlugins.pure.src;
          # }
          # {
          #   name = "tide";
          #   src = pkgs.fishPlugins.tide.src;
          # }
        ];
        interactiveShellInit = ''
          set fish_greeting
        '';
      };
    };
}
