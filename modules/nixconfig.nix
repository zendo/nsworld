{inputs, config, lib, ... }:

{
  nix.settings = {
    # sandbox = true; # true by default
    auto-optimise-store = true;
    trusted-users = [ "@wheel" ];
    substituters = lib.mkBefore [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
      "https://nix-community.cachix.org"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
    # trusted-substituters = [
    # ]; # List of binary cache URLs that non-root users can use
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

  };

  nix = {
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      warn-dirty = false
      flake-registry = /etc/nix/registry.json
    '';
    # flake-registry = https://cdn.jsdelivr.net/gh/NixOS/flake-registry/flake-registry.json

    # registry = {
    #   nixpkgs.flake = inputs.nixpkgs;
    # };

    # nixPath = [
    # ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };
}
