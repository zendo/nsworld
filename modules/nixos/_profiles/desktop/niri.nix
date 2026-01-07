{
  flake.modules.nixos.niri =
    { self, ... }:
    {
      imports = [ self.modules.nixos.wm ];
      programs.niri.enable = true;
      services.displayManager.dms-greeter.compositor.name = "niri";
    };
}
