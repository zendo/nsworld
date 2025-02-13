{ ... }:
{
  programs.fish = {
    enable = false;
    generateCompletions = false;
    interactiveShellInit = ''
      # Disable the greeting message.
      set fish_greeting
    '';
  };
}
