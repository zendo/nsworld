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
  system.stateVersion = "22.05";
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
    nixos-option
    nixos-generators
  ];

  documentation = {
    enable = false;
    nixos.enable = false;
  };

  nix = {
    # package = pkgs.nixUnstable;
    useSandbox = true;
    autoOptimiseStore = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      warn-dirty = false
      flake-registry = /etc/nix/registry.json
    '';

    binaryCaches = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
  };



}
