{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    # alejandra
    nixfmt
    # lorri
    # cachix
    # comma # ,
    nix-tree
    nurl
    nix-init
    nix-update
    # nix-prefetch
    # nix-template
    dix # diff
    nix-output-monitor
    nix-search-tv
    nixpkgs-track
    disko
    nixos-anywhere
    colmena
    inputs.deploy-rs.packages.${stdenv.hostPlatform.system}.deploy-rs

    # persistent cache
    inputs.self.formatter.${stdenv.hostPlatform.system}

    (writeScriptBin "nsearch" ''nix search nixpkgs "$@"'')
    (writeScriptBin "nsa" (builtins.readFile "${nix-search-tv.src}/nixpkgs.sh"))
  ];

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "${config.home.homeDirectory}/nsworld";
    };

    nix-index = {
      # enable = true;
    };

    nix-your-shell = {
      enable = true;
    };

    # echo "use flake" >> .envrc && direnv allow
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
