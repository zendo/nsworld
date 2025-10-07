{
  pkgs,
  inputs,
  config,
  username,
  ...
}:
{
  imports = [
    ./ssh.nix
    ./git.nix
    ./cli.nix
    ./zsh.nix
    ./fish.nix
    ./alias.nix
    ./files.nix
    ./nvim.nix
    ./nix-tools.nix
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    enableNixpkgsReleaseCheck = false;
    stateVersion = "25.05";

    sessionPath = [
      "${../dotfiles/bin}"
      "${config.home.homeDirectory}/.local/bin"
    ];

    sessionVariables = {
      VISUAL = "micro";
      EDITOR = "micro";
    };

    shellAliases = {
      nixgl = "nix run --impure github:guibou/nixGL";
    };

    packages = with pkgs; [
      dippi
      goodvibes
      (config.lib.nixGL.wrap pkgs.kitty)
      (config.lib.nixGL.wrap pkgs.google-chrome)
    ];
  };

  programs = {
    home-manager.enable = true;
    # mpv.package = config.lib.nixGL.wrap pkgs.mpv;
  };

  # nixGL
  nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
    # A wrapper script named nixGLWrp
    installScripts = [ "mesa" ];
  };

  nix = {
    registry = {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
      n.flake = inputs.nixpkgs;
    };
    package = pkgs.nixVersions.latest; # need for nix.settings
    settings = {
      warn-dirty = false;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
  };
}
