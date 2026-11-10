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
}
