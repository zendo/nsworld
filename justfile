set shell := ["bash", "-uc"]

host := `uname -n`
user := `loginctl --no-legend list-users | awk '{print $2;}'`
home_dir := env_var('HOME')

[private]
_default:
    @just --choose --unsorted

justfile-windows:
    just dotfiles/Windows/

# switch / boot / test
os *args:
    nixos-rebuild --sudo --flake .#"{{ host }}" {{ args }}

up *inputs:
    nix flake update --commit-lock-file {{ inputs }}

diff:
    nix profile diff-closures --profile /nix/var/nix/profiles/system

diff-dix:
    dix $(\ls -dv /nix/var/nix/profiles/system-*-link | tail -2)

diff-commits:
    #!/usr/bin/env bash
    osrev=$(nixos-version --revision)
    nixpkgs=$(git ls-remote https://github.com/NixOS/nixpkgs refs/heads/nixos-unstable | awk '{print $1}')
    if [[ "$osrev" = "$nixpkgs" ]]; then
        echo "There is no update."
    else
        xdg-open https://github.com/NixOS/nixpkgs/compare/"$osrev"..."$nixpkgs"
    fi

gc-all:
    sudo nix-collect-garbage -d && nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot

# switch / build
hm *args:
    home-manager --flake .#"{{ user }}" {{ args }}

hm-diff:
    nix profile diff-closures --profile ~/.local/state/nix/profiles/home-manager

# livecd-minimal / livecd-standard
build-iso *args:
    nix build .#nixosConfigurations.{{ args }}.config.system.build.isoImage

build-wsl-installer:
    sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder

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
    --eval '(org-babel-tangle-file "~/.config/doom/doom-emacs.org")'
