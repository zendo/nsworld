{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  nix = {
    channel.enable = false;

    registry = lib.mkMerge [
      { n.flake = inputs.nixpkgs; }
      { self.flake = inputs.self; }
    ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };

    package = inputs.determinate.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      warn-dirty = false;
      auto-optimise-store = lib.mkDefault true;
      auto-allocate-uids = true;
      use-cgroups = true;
      # max-jobs = 8; # limit the number of parallel jobs
      flake-registry = ""; # disable global registry

      # for direnv GC roots
      # keep-outputs = true;
      # keep-derivations = true;

      substituters = [
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        # "https://mirrors.ustc.edu.cn/nix-channels/store"
        # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.garnix.io"
        # "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      trusted-users = [ "@wheel" ];

      experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
        # Allows Nix to execute builds inside cgroups
        "cgroups"
        # Allows Nix to automatically pick UIDs for builds, rather than creating nixbld* user accounts
        "auto-allocate-uids"
      ];
    }; # end of settings
  }; # edd of nix
}
