set shell := ["bash", "-uc"]

# alias c := check
# alias b := build

host := `uname -n`
user := `loginctl --no-legend list-users | awk '{print $2;}'`
home_dir := env_var('HOME')

default:
    @just --choose

os-switch:
    nixos-rebuild --use-remote-sudo --flake .#"{{host}}" switch

os-boot:
    nixos-rebuild --use-remote-sudo --flake .#"{{host}}" boot

os-upgrade:
    nix flake update --commit-lock-file && \
      nixos-rebuild --use-remote-sudo --flake .#"{{host}}" boot

# nix run n#nvd -- diff $(\ls -d1v /nix/var/nix/profiles/system-*-link|tail -n 2)
os-diff:
    nix profile diff-closures --profile /nix/var/nix/profiles/system

hm-switch:
    home-manager switch --flake .#"{{user}}"

hm-diff:
    nix profile diff-closures --profile ~/.local/state/nix/profiles/home-manager

build-livecd-graphical:
    nix build .#nixosConfigurations.livecd-graphical.config.system.build.isoImage

build-livecd-minimal:
    nix build .#nixosConfigurations.livecd-minimal.config.system.build.isoImage

build-wsl-installer:
    nix build .#nixosConfigurations.wsl.config.system.build.tarballBuilder
    # sudo ./result/bin/nixos-wsl-tarball-builder ~/nixos-wsl.tar.gz

nix-tree-with-gcroots:
    nix-store --gc --print-roots | rg -v '/proc/' | rg -Po '(?<= -> ).*' | xargs -o nix-tree

nix-index-database-update:
    #!/usr/bin/env bash
    filename="index-x86_64-$(uname | tr '[:upper:]' '[:lower:]')"
    mkdir -p ~/.cache/nix-index
    pushd ~/.cache/nix-index > /dev/null
    wget -q -N https://github.com/nix-community/nix-index-database/releases/latest/download/"$filename"
    ln -f "$filename" files
    popd > /dev/null
    ls -l ~/.cache/nix-index

non-nixos-setup:
    #!/usr/bin/env bash
    sudo tee -a /etc/nix/nix.conf <<EOF
    experimental-features = nix-command flakes
    trusted-users = root @wheel {{user}}
    substituters = https://mirror.sjtu.edu.cn/nix-channels/store
    EOF
