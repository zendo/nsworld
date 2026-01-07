{
  flake.modules.nixos.hyprland =
    { self, ... }:
    {
      imports = [ self.modules.nixos.wm ];
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
    };
}
