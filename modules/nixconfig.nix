{inputs, config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable; # nix v2.5pre
    useSandbox = true;
    autoOptimiseStore = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
    extraOptions =
      let flakesEmpty = pkgs.writeText "flakes-empty.json" (builtins.toJSON { flakes = []; version = 2; });
      in ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      flake-registry = ${flakesEmpty}
    '';
    # gobal registry
    # flake-registry = https://cdn.jsdelivr.net/gh/NixOS/flake-registry/flake-registry.json
    # flake-registry = ${flakesEmpty}
    registry.nixpkgs.flake = inputs.nixpkgs;
    # registry.nixpkgs = {
    #   from = {
    #     id = "nixpkgs";
    #     type = "indirect";
    #   };
    #   to = {
    #     owner = "NixOS";
    #     ref = "nixos-21.11";
    #     repo = "nixpkgs";
    #     type = "github";
    #   };
    # };
    binaryCaches = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
}
