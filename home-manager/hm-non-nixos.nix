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
    ./programs/ssh.nix
    ./programs/git.nix
    ./programs/cli.nix
    ./programs/zsh.nix
    ./programs/fish.nix
    ./programs/nix-tools.nix
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
      kitty
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
    };
  };

  news.display = "silent";
  programs.home-manager.enable = true;
  # https://github.com/nix-community/home-manager/blob/master/docs/manual/usage/gpu-non-nixos.md
  targets.genericLinux.gpu.enable = true;
}
