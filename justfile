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
    nix flake update && \
      nixos-rebuild --use-remote-sudo --flake .#"{{host}}" boot

# nix run n#nvd -- diff $(\ls -d1v /nix/var/nix/profiles/system-*-link|tail -n 2)
os-diff:
    nix profile diff-closures --profile /nix/var/nix/profiles/system

hm-switch:
    home-manager switch --flake .#"{{user}}"

hm-diff:
    nix profile diff-closures --profile ~/.local/state/nix/profiles/home-manager

build-vm:
    nixos-rebuild build-vm --flake .#vmtest

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

backup-data:
    #!/usr/bin/env bash
    rsync -avhpL ~/.ssh ~/Documents/homeBackups/
    rsync -avhpL ~/.config/sops ~/Documents/homeBackups/

    rsync -avhpL ~/.mozilla ~/Documents/homeBackups/
    # rsync -avhpL ~/.config/chromium ~/Documents/homeBackups/
    # rsync -avhpL ~/.config/google-chrome ~/Documents/homeBackups/
    rsync -avhpL ~/.config/fcitx5/conf ~/Documents/homeBackups/


ln-ibus-rime:
    #! /usr/bin/env bash
    if [[ ! -e "$HOME/.config/ibus/rime" ]]; then
        mkdir "$HOME/.config/ibus/rime"
    fi

    ln -sfv "$(pwd)"/dotfiles/rime/default.custom.yaml "$HOME"/.config/ibus/rime/default.custom.yaml
    ln -sfv "$(pwd)"/dotfiles/rime/ibus_rime.custom.yaml "$HOME"/.config/ibus/rime/ibus_rime.custom.yaml

    # rime-ice
    ln -sfv "$(pwd)"/dotfiles/rime/rime_ice.custom.yaml "$HOME"/.config/ibus/rime/rime_ice.custom.yaml
    # rime-frost
    ln -sfv "$(pwd)"/dotfiles/rime/rime_frost.custom.yaml "$HOME"/.config/ibus/rime/rime_frost.custom.yaml

ln-fcitx-conf-rime:
    #! /usr/bin/env bash
    if [[ ! -e "$HOME/.local/share/fcitx5/rime" ]]; then
        mkdir "$HOME/.local/share/fcitx5/rime"
    fi

    ln -sfv "$(pwd)"/dotfiles/rime/default.custom.yaml "$HOME"/.local/share/fcitx5/rime/default.custom.yaml

    # rime-ice
    ln -sfv "$(pwd)"/dotfiles/rime/rime_ice.custom.yaml "$HOME"/.local/share/fcitx5/rime/rime_ice.custom.yaml
    # rime-frost
    ln -sfv "$(pwd)"/dotfiles/rime/rime_frost.custom.yaml "$HOME"/.local/share/fcitx5/rime/rime_frost.custom.yaml

    # fcitx5-conf
    cp "$(pwd)"/dotfiles/fcitx5/classicui.conf "$HOME"/.config/fcitx5/conf/classicui.conf
    cp "$(pwd)"/dotfiles/fcitx5/clipboard.conf "$HOME"/.config/fcitx5/conf/clipboard.conf
    cp "$(pwd)"/dotfiles/fcitx5/config "$HOME"/.config/fcitx5/config
    cp "$(pwd)"/dotfiles/fcitx5/profile "$HOME"/.config/fcitx5/profile
