/*
 
 git clone https://github.com/nix-community/NixOS-WSL.git
 
 nix build .#nixosConfigurations.mysystem.config.system.build.installer
 
 flake.nix:
 inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
 home-manager.url = "github:nix-community/home-manager";
 home-manager.inputs.nixpkgs.follows = "nixpkgs";
 &&
 home-manager modules ...
 
 hm-pkgs.nix
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
    p7zip
    fd
    ripgrep
    helix
    neovim
    emacs
    gdu
    duf
    pfetch
    neofetch
    wget
    curl
    bind
    hack-font
    fira-code
    jetbrains-mono
  ];

  environment.shellAliases = {
    wsl-proxy = "export http_proxy=http://192.168.2.118:10809 ; \\
    export https_proxy=http://192.168.2.118:10809";
    # wsl-switch = "";
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    warn-dirty = false;
    auto-optimise-store = true;
    trusted-users = ["@wheel"];
    flake-registry = "https://cdn.jsdelivr.net/gh/NixOS/flake-registry/flake-registry.json";
    substituters = lib.mkForce [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
