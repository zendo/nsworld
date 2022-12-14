{ lib, config, inputs, ... }: {

  programs.nix-ld.enable = true;

  nix = {
    # nix registry list
    registry = lib.mapAttrs'
      (
        n: v: lib.nameValuePair n { flake = v; }
      )
      inputs;

    # echo $NIX_PATH | tr ":" "\n"
    # compatible for old nix
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

    settings = {
      # keep-outputs = true
      # keep-derivations = true
      warn-dirty = false;
      auto-optimise-store = true;
      flake-registry = /etc/nix/registry.json;

      substituters = lib.mkForce [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
        # "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://r.zhullyb.top/https://nix-community.cachix.org"
        "https://r.zhullyb.top/https://cache.nixos.org"
      ];

      trusted-users = [ "root" "@wheel" ];
      # List of binary cache URLs that non-root users can use
      trusted-substituters = [
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      experimental-features = [ "nix-command" "flakes" "repl-flake" "auto-allocate-uids" "cgroups" ];
      auto-allocate-uids = true; # Nix 2.12.0
      use-cgroups = true; # Nix 2.12.0
    };
    nrBuildUsers = 0; # Nix 2.12.0
  };
}
