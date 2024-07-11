{ self, ... }:
{
  flake.nixosModules = {
    default = {
      imports = self.lib.umport {
        path = ./.;
        exclude = [
          ./desktop
          ./flake-module.nix
        ];
      };
    };

    gnome = {
      imports = [ ./desktop/gnome.nix ];
    };

    kde = {
      imports = [ ./desktop/kde.nix ];
    };

    sway = {
      imports = [
        ./desktop/wm.nix
        ./desktop/wm-sway.nix
      ];
    };

    hyprland = {
      imports = [
        ./desktop/wm.nix
        ./desktop/wm-hyprland.nix
      ];
    };
  };
}
