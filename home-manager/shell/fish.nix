{ pkgs, ... }:
{
  programs.fish = {
    # enable = true;
    generateCompletions = true;
    plugins = [
      # {
      #   name = "pure";
      #   src = pkgs.fishPlugins.pure.src;
      # }
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
    interactiveShellInit = ''
      # Disable the greeting message.
      set fish_greeting
    '';
  };
}
