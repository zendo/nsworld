{ inputs, ... }:
{
  flake.nixosModules = {
    default = (inputs.import-tree ./.);
    homeManagerInit.imports = [ ../home/hm-as-module.nix ];
    laptop.imports = [ ./_desktop/laptop.nix ];
    gnome.imports = [ ./_desktop/gnome.nix ];
    kde.imports = [ ./_desktop/kde.nix ];

    cosmic = {
      services.desktopManager.cosmic.enable = true;
      services.displayManager.cosmic-greeter.enable = true;
    };

    niri = {
      imports = [ ./_desktop/wm.nix ];
      programs.niri.enable = true;
    };

    hyprland = {
      imports = [ ./_desktop/wm.nix ];
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
    };

    sway =
      { pkgs, ... }:
      {
        imports = [ ./_desktop/wm.nix ];
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
