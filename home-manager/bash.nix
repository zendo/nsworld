{ ... }:
{
  programs.bash = {
    enable = true;
  };

  # ~/.inputrc
  programs.readline = {
    enable = true;
    bindings = {
      "\\C-h" = "backward-kill-word";
    };
    extraConfig = ''
      set bell-style none
      set completion-ignore-case on

      # Display matches for ambiguous patterns at first tab press
      set show-all-if-ambiguous on
    '';
  };
}
