# git clone https://github.com/nzbr/NixOS-WSL.git
# nix build .#nixosConfigurations.mysystem.config.system.build.installer

# inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
# home-manager.url = "github:nix-community/home-manager";
# home-manager.inputs.nixpkgs.follows = "nixpkgs";
# configuration.nix : defaultUser
# ./wsl.nix
#   home-manager.nixosModules.home-manager
# {
#   home-manager.useGlobalPkgs = true;
#   home-manager.useUserPackages = true;
#   home-manager.users.iab = import ./homefiles/home.nix;
# }
#   {
#     nixpkgs.config = {
#       allowUnfree = true;
#       allowBroken = true;
#       allowUnsupportedSystem = true;
#     };
#   }

# ssr = "export http_proxy=http://192.168.2.118:10809 ; \\
#     export https_proxy=http://192.168.2.118:10809";

{ config, lib, pkgs, ... }:

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

  programs.command-not-found.enable = false;

  documentation = {
    enable = false;
    nixos.enable = false;
  };

  nix.settings = {
    warn-dirty = false;
    auto-optimise-store = true;
    trusted-users = [ "@wheel" ];
    substituters = lib.mkBefore [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # users.defaultUserShell = pkgs.zsh;
}
