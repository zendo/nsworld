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

    cosmic = {
      imports = [ ./desktop/cosmic.nix ];
    };

    niri = {
      imports = [
        ./desktop/wm.nix
        ./desktop/wm-dm.nix
        ./desktop/wm-niri.nix
      ];
    };

    sway = {
      imports = [
        ./desktop/wm.nix
        ./desktop/wm-dm.nix
        ./desktop/wm-sway.nix
      ];
    };

    hyprland = {
      imports = [
        ./desktop/wm.nix
        ./desktop/wm-dm.nix
        ./desktop/wm-hyprland.nix
      ];
    };
  };
}
