# git clone https://github.com/nzbr/NixOS-WSL.git
# nix build .#nixosConfigurations.mysystem.config.system.build.installer

# inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
# home-manager.url = "github:nix-community/home-manager";
# home-manager.inputs.nixpkgs.follows = "nixpkgs";
#
# add home-manager modules
# ssr ip change

{ config, lib, pkgs, inputs, ... }:

{
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "22.05";

  environment.systemPackages = with pkgs; [
    binutils
    tree
    p7zip
    fd
    ripgrep
    mg
    micro
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

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    warn-dirty = false;
    auto-optimise-store = true;
    trusted-users = [ "@wheel" ];
    flake-registry = "https://cdn.jsdelivr.net/gh/NixOS/flake-registry/flake-registry.json";
    substituters = lib.mkForce [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  nix = {
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "nixos-config=${inputs.self}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}
