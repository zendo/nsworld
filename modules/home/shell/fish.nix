{
  flake.modules.nixos.fish = {
    documentation.man.cache.enable = false;
    programs.fish.enable = true;
  };

  flake.modules.homeManager.fish =
    {
      pkgs,
      lib,
      osConfig ? null,
      ...
    }:
    lib.mkIf (osConfig == null || osConfig.programs.fish.enable) {

      programs.man.generateCaches = false;

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
