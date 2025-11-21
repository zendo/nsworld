{
  pkgs,
  inputs,
  config,
  username,
  ...
}:
{
  imports = [
    ./misc/alias.nix
    ./misc/files.nix
    # shell
    ./shell/zsh.nix
    ./shell/fish.nix
    ./shell/atuin.nix
    ./shell/starship.nix
    ./shell/zellij.nix
    # programs
    ./programs/ssh.nix
    ./programs/git.nix
    ./programs/cli.nix
    ./programs/ghostty.nix
    ./programs/nix-tools.nix
    # editor
    ./editor/micro.nix
    ./editor/helix.nix
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";

    sessionPath = [
      "${../dotfiles/bin}"
      "${config.home.homeDirectory}/.local/bin"
    ];

    sessionVariables = {
      VISUAL = "micro";
      EDITOR = "micro";
    };

    packages = with pkgs; [
      dippi
      goodvibes
    ];
  };

  nix = {
    package = pkgs.nixVersions.stable;
    registry = {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
      n.flake = inputs.nixpkgs;
    };
    settings = {
      warn-dirty = false;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      substituters = [
        # "https://nix-community.cachix.org"
        "https://cache.garnix.io"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };

  news.display = "silent";
  programs.home-manager.enable = true;
  # https://github.com/nix-community/home-manager/blob/master/docs/manual/usage/gpu-non-nixos.md
  targets.genericLinux.gpu.enable = true;
}
