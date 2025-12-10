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

    homeManagerInit.imports = [ ../../home-manager/hm-as-module.nix ];
    laptopPowerPlans.imports = [ ./profiles/laptop-power-plans.nix ];

    kde.imports = [ ./desktop/kde.nix ];
    gnome.imports = [ ./desktop/gnome.nix ];

    cosmic = {
      services.desktopManager.cosmic.enable = true;
      services.displayManager.cosmic-greeter.enable = true;
    };

    niri = {
      imports = [ ./desktop/wm.nix ];
      programs.niri.enable = true;
    };

    hyprland = {
      imports = [ ./desktop/wm.nix ];
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
    };

    sway =
      { pkgs, ... }:
      {
        imports = [ ./desktop/wm.nix ];
        programs.sway = {
          enable = true;
          wrapperFeatures.gtk = true;
          extraPackages = [
            pkgs.autotiling-rs
          ];
        };
      };
  };
}
