{
  config,
  lib,
  inputs,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
    # allowBroken = true;
    # allowUnsupportedSystem = true;
  };

  nix.settings = {
    # keep-outputs = true
    # keep-derivations = true
    warn-dirty = false;
    auto-optimise-store = true;
    flake-registry = /etc/nix/registry.json;
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];

    trusted-users = ["root" "@wheel"];
    # List of binary cache URLs that non-root users can use
    trusted-substituters = [
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix = {
    # nix registry list
    registry =
      lib.mapAttrs' (
        n: v:
          lib.nameValuePair n {flake = v;}
      )
      inputs;

    # echo $NIX_PATH | tr ":" "\n" # reboot needs
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "nixos-config=${inputs.self}"
      "home-manager=${inputs.home-manager}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    gc = {
      automatic = true;
      # options = "--max-freed 10G";
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };
}
