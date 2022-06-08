/*
 git clone https://github.com/nix-community/NixOS-WSL.git
 
 nix build .#nixosConfigurations.mysystem.config.system.build.installer
 
 add inputs: nixpkgs hm
 add modules: home-manager
 */
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "22.05";

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    p7zip
    fd
    ripgrep
    gdu
    duf
    pfetch
    neofetch
    wget
    curl
    bind
    nix-bash-completions

    # helix
    neovim
    emacs
    hack-font
    fira-code
    jetbrains-mono
  ];

  environment.shellAliases = {
    wsl-proxy = "export http_proxy=http://192.168.2.118:10809 ; \\
    export https_proxy=http://192.168.2.118:10809";
    # wsl-switch = "";
  };

  nix.settings = {
    auto-optimise-store = true;
    trusted-users = ["@wheel"];
    flake-registry = /etc/nix/registry.json;
    substituters = lib.mkForce [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    # allowBroken = true;
    # allowUnsupportedSystem = true;
  };

  nix = {
    # nix registry list
    registry =
      lib.mapAttrs' (
        n: v:
          lib.nameValuePair n {flake = v;}
      )
      inputs;

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "nixos-config=${inputs.self}"
      "home-manager=${inputs.home-manager}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}
