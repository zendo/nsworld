{ inputs, ... }:
{
  flake.modules.homeManager.non-nixos =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        dippi
      ];

      news.display = "silent";
      programs.home-manager.enable = true;
      manual.manpages.enable = false; # HM manuals
      programs.man.enable = false; # man-db
      # https://github.com/nix-community/home-manager/blob/master/docs/manual/usage/gpu-non-nixos.md
      targets.genericLinux.gpu.enable = true;

      # ========================================================
      #  Nix Settings
      # ========================================================
      nix = {
        package = pkgs.nixVersions.stable;
        registry = {
          self.flake = inputs.self;
          nixpkgs.flake = inputs.nixpkgs;
          n.flake = inputs.nixpkgs;
        };
        settings = {
          warn-dirty = false;
          experimental-features = [
            "flakes"
            "nix-command"
          ];
          substituters = [
            # "https://nix-community.cachix.org"
            "https://cache.nixos.org"
          ];
          trusted-public-keys = [
            # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ];
        }; # end of settings
      }; # end of nix

      # ========================================================
      #  Fonts Config
      # ========================================================
      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          monospace = [
            "Noto Sans Mono CJK SC"
            "Sarasa Mono SC"
            "DejaVu Sans Mono"
          ];
          sansSerif = [
            "Noto Sans CJK SC"
            "Source Han Sans SC"
            "DejaVu Sans"
          ];
          serif = [
            "Noto Serif CJK SC"
            "Source Han Serif SC"
            "DejaVu Serif"
          ];
        }; # end of defaultFonts
      }; # end of fontconfig
    };
}
