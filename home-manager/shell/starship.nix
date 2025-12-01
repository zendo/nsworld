{ ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    # enableFishIntegration = false;
    settings = {
      command_timeout = 3000; # Timeout for commands executed
      # add_newline = false; # Print a new line at the start of the prompt
      # line_break.disabled = true; # Make prompt a single line instead of two lines
      # cmd_duration.disabled = true; # disable "It took xxs"
      # character = {
      #   success_symbol = "[>](bold green)";
      #   error_symbol = "[✗](bold red)";
      # };
      # nix_shell = {
      #   format = "❄️ via [☃️ $state( \($name\))](bold blue)";
      #   symbol = "nix ";
      # };
    };
  };
}
