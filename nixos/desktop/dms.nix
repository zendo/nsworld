{ ... }:
{
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
  };

  programs.dms-shell = {
    enable = true;
  };

  programs.dsearch.enable = true;
}
