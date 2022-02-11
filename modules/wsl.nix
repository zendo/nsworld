# git clone git://github.com/Trundle/NixOS-WSL
# cp wsl ./
# nix build .#nixosConfigurations.mysystem.config.system.build.tarball
# inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
# (import ./wsl.nix)
#   {
#     nixpkgs.config = {
#       allowUnfree = true;
#       allowBroken = true;
#       allowUnsupportedSystem = true;
#     };
#   }

{ config, lib, pkgs, ... }:

{
  time.timeZone = "Asia/Shanghai";

  environment.systemPackages = with pkgs; [
    binutils
    tree
    p7zip
    fd
    ripgrep
    mg
    helix
    gdu
    duf
    pfetch
    neofetch
    wget
    curl
    bind
    git

    fish
    exa
    bat
    zoxide
    mcfly
    fzf
    skim

    # CLI
    powertop
    unp
    unrar
    btop
    bottom # btm
    cht-sh
    trash-cli
    translate-shell

    # Develop
    # gcc
    # cmake
    # gnumake
    # nodejs
    gitui
    jq
    jql
    cloc # count code lines
    sqlite
    openssl
    python3

    # Network
    lsof
    elinks
    dnspeep
    bandwhich
    traceroute
    speedtest-cli

    # NIX TOOLS
    nix-bash-completions
    nixpkgs-fmt
    nixfmt
    rnix-lsp
    direnv
    lorri
    niv
    # nvd diff /nix/var/nix/profiles/system-{14,15}-link
    nvd
    cachix
    nixos-generators
  ];

  documentation = {
    enable = false;
    nixos.enable = false;
  };

  nix.settings = {
    warn-dirty = false;
    auto-optimise-store = true;
    trusted-users = [ "@wheel" ];
    flake-registry = /etc/nix/registry.json;
    substituters = lib.mkBefore [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
      "https://nix-community.cachix.org"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
    # trusted-substituters = [
    # ]; # List of binary cache URLs that non-root users can use
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };



}
