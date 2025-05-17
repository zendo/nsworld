set shell := ["bash", "-uc"]

host := `uname -n`
user := `loginctl --no-legend list-users | awk '{print $2;}'`
home_dir := env_var('HOME')

_default:
    @just --choose --unsorted

switch:
    nixos-rebuild --sudo --flake .#"{{ host }}" switch

boot:
    nixos-rebuild --sudo --flake .#"{{ host }}" boot

upgrade:
    nix flake update --commit-lock-file && \
      nixos-rebuild --sudo --flake .#"{{ host }}" boot

build-os-nom:
    nom build .#nixosConfigurations."{{ host }}".config.system.build.toplevel

diff:
    nix profile diff-closures --profile /nix/var/nix/profiles/system

diff-commits:
    #!/usr/bin/env bash
    osrev=$(nixos-version --revision)
    nixpkgs=$(git ls-remote https://github.com/NixOS/nixpkgs refs/heads/nixos-unstable | awk '{print $1}')
    if [[ "$osrev" = "$nixpkgs" ]]; then
        echo "There is no update."
    else
        xdg-open https://github.com/NixOS/nixpkgs/compare/"$osrev"..."$nixpkgs"
    fi

hm-switch:
    home-manager switch --flake .#"{{ user }}"

hm-diff:
    nix profile diff-closures --profile ~/.local/state/nix/profiles/home-manager

build-livecd-standard:
    nix build .#nixosConfigurations.livecd-standard.config.system.build.isoImage

build-livecd-minimal:
    nix build .#nixosConfigurations.livecd-minimal.config.system.build.isoImage

build-wsl-installer:
    sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder

nix-tree-with-gcroots:
    nix-store --gc --print-roots | rg -v '/proc/' | rg -Po '(?<= -> ).*' | xargs -o nix-tree

hash2sri:
    nix hash convert --hash-algo sha256 --to sri "$2"

nix-index-database-update:
    #!/usr/bin/env bash
    filename="index-x86_64-$(uname | tr '[:upper:]' '[:lower:]')"
    mkdir -p ~/.cache/nix-index
    pushd ~/.cache/nix-index > /dev/null
    wget -q -N https://github.com/nix-community/nix-index-database/releases/latest/download/"$filename"
    ln -f "$filename" files
    popd > /dev/null
    ls -l ~/.cache/nix-index
    echo -e "\033[32m \n nix-index datebase update successfully. \033[0m"

non-nixos-setup:
    #!/usr/bin/env bash
    sudo tee -a /etc/nix/nix.conf <<EOF
    experimental-features = nix-command flakes
    trusted-users = root @wheel {{ user }}
    substituters = https://mirror.sjtu.edu.cn/nix-channels/store
    EOF

emacs-ob-tangle:
    emacs -Q --batch \
    -l org \
    --eval '(setq vc-follow-symlinks nil)' \
    --eval '(org-babel-tangle-file "~/.config/emacs/all-emacs.org")'

emacs-ob-tangle-doom:
    emacs -Q --batch \
    -l org \
    --eval '(setq vc-follow-symlinks nil)' \
    --eval '(org-babel-tangle-file "~/.config/doom/config.org")'
