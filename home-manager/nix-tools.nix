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
    nixpkgs-track
    disko
    nixos-anywhere
    inputs.deploy-rs.packages.${system}.deploy-rs

    # persistent cache
    inputs.self.formatter.${system}
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
