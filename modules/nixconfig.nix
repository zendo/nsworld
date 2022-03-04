{inputs, config, lib, ... }:

{
  nix.settings = {
    # keep-outputs = true
    # keep-derivations = true
    warn-dirty = false;
    auto-optimise-store = true;

    flake-registry = "https://cdn.jsdelivr.net/gh/NixOS/flake-registry/flake-registry.json";
    # flake-registry = /etc/nix/registry.json;
    substituters = lib.mkBefore [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];

    trusted-users = [ "@wheel" ];
    trusted-substituters = [
    ]; # List of binary cache URLs that non-root users can use
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nix = {

    # Set the $NIX_PATH entry for nixpkgs. This is necessary in
    # this setup with flakes, otherwise commands like `nix-shell
    # -p pkgs.htop` will keep using an old version of nixpkgs
    # nixPath = [
    #   "nixpkgs=${inputs.nixpkgs}"
    #   "nixpkgs-unstable=${inputs.unstable}"
    # ];
    # Same as above, but for `nix shell nixpkgs#htop`
    # FIXME: for non-free packages you need to use `nix shell --impure`
    # registry = {
    #   nixpkgs.flake = inputs.nixpkgs;
    #   nixpkgs-unstable.flake = inputs.unstable;
    # };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };
}
