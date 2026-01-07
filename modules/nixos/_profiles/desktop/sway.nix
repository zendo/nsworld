{
  flake.modules.nixos.sway =
    { pkgs, self, ... }:
    {
      imports = [ self.modules.nixos.wm ];
      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraPackages = [
          pkgs.autotiling-rs
        ];
      };
    };
}
