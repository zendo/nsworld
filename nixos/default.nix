{ self, ... }:
{
  flake.nixosModules = {
    default.imports = self.lib.umport {
      path = ./.;
      exclude = [
        ./desktop
        ./profiles
        ./default.nix
      ];
    };

    homeManagerInit.imports = [ ../home-manager/hm-as-module.nix ];
    laptopPowerPlans.imports = [ ./profiles/laptop-power-plans.nix ];

    kde.imports = [ ./desktop/kde.nix ];
    gnome.imports = [ ./desktop/gnome.nix ];
    cosmic.imports = [ ./desktop/cosmic.nix ];
    niri.imports = [ ./desktop/wm-niri.nix ];
    sway.imports = [ ./desktop/wm-sway.nix ];
    hyprland.imports = [ ./desktop/wm-hyprland.nix ];
  };
}
