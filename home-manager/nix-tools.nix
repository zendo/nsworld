{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    # alejandra
    nixfmt-rfc-style
    # lorri
    # cachix
    # comma # ,
    nix-tree
    nurl
    nix-update
    # nix-prefetch
    # nix-template
    nix-output-monitor
    disko
    nixos-anywhere

    nix-init
    inputs.deploy-rs.packages.${system}.deploy-rs
    inputs.self.formatter.${system} # persistent cache
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
