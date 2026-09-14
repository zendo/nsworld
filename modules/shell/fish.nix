{
  flake.modules.nixos.fish = { pkgs, ... }: {

    documentation.man.cache.enable = false;

    environment.systemPackages = with pkgs; [
      fishPlugins.pure
      # fishPlugins.tide
    ];

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
    };
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
