/*
  # https://github.com/NixOS/nix/pull/13220
  nix eval --no-eval-cache .\#nixosConfigurations.yoga.config.system.build.toplevel \
    --option eval-profiler flamegraph \
    --option eval-profile-file >(zstd -of nix.profile.zstd)
  zstd -d nix.profile.zstd
  flamegraph.pl nix.profile > nixprofile.svg
*/
{ self, ... }:
{
  flake.nixosModules = {
    default.imports = self.lib.umport {
      path = ./.;
      exclude = [
        ./_desktop
        ./default.nix
      ];
    };
    homeManagerInit.imports = [ ../home/hm-as-module.nix ];
    laptop.imports = [ ./_desktop/laptop.nix ];
    gnome.imports = [ ./_desktop/gnome.nix ];
    kde.imports = [ ./_desktop/kde.nix ];
    cosmic.imports = [ ./_desktop/cosmic.nix ];
    niri.imports = [ ./_desktop/niri.nix ];

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
