{inputs, config, pkgs, ... }:

{
  nix = {
    # package = pkgs.nixUnstable;
    useSandbox = true;
    autoOptimiseStore = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      warn-dirty = false
      flake-registry = /etc/nix/registry.json
    '';
    # flake-registry = https://cdn.jsdelivr.net/gh/NixOS/flake-registry/flake-registry.json

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };

    binaryCaches = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
      "https://nix-community.cachix.org"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];

    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
    # optimise = {
    #   automatic = true;
    #   dates = [ "weekly" ];
    # };
  };
}
