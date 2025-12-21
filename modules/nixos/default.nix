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
    default.imports = self.lib.custom.umport {
      path = ./.;
      exclude = [
        ./desktop
        ./default.nix
      ];
    };
    homeManagerInit.imports = [ ../home/hm-as-module.nix ];
    laptop.imports = [ ./desktop/laptop.nix ];
    gnome.imports = [ ./desktop/gnome.nix ];
    kde.imports = [ ./desktop/kde.nix ];
    cosmic.imports = [ ./desktop/cosmic.nix ];
    niri.imports = [ ./desktop/niri.nix ];
    sway.imports = [ ./desktop/sway.nix ];
    hyprland.imports = [ ./desktop/hyprland.nix ];
  };
}
