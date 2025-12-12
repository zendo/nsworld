set shell := ["bash", "-uc"]

host := `uname -n`
user := `id -un`
home_dir := env_var('HOME')

[private]
_default:
    @just --choose --unsorted

[group('just')]
justfile-windows:
    just dotfiles/Windows/

# switch / boot / test
os *args:
    nixos-rebuild --sudo --flake .\#"{{ host }}" {{ args }}

diff:
    nix profile diff-closures --profile /nix/var/nix/profiles/system

diff-hm:
    nix profile diff-closures --profile ~/.local/state/nix/profiles/home-manager

diff-dix:
    dix $(\ls -dv /nix/var/nix/profiles/system-*-link | tail -2)

diff-commit:
    #!/usr/bin/env bash
    git commit -m "flake.lock: Update details on host.{{ host }}" \
    -m "$(dix $(\ls -dv /nix/var/nix/profiles/system-*-link | tail -2) | tail -n +3)" --allow-empty

gca:
    sudo nix-collect-garbage -d && nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot

up:
    #!/usr/bin/env bash
    before_update=$(nix eval --raw .\#nixosConfigurations."{{ host }}".config.system.nixos.revision)
    nix flake update --commit-lock-file
    after_update=$(nix eval --raw .\#nixosConfigurations."{{ host }}".config.system.nixos.revision)
    if [[ "$before_update" = "$after_update" ]]; then
        echo -e "\n Nixpkgs is no update."
    else
        OLD_MSG=$(git log -1 --pretty=%B)
        ADD_MSG=$(echo https://github.com/NixOS/nixpkgs/compare/"$before_update"..."$after_update")
        echo -e "\033[1;33m \n Nixpkgs Comparing changes: \033[0m"
        echo -e "\033[32m $ADD_MSG \033[0m"
        git commit --amend --quiet -m "$OLD_MSG" -m "Nixpkgs Comparing changes: $ADD_MSG"
    fi

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

backup-my-data:
    #!/usr/bin/env bash
    BACKUP_DIR="$HOME/Documents/mybackup"
    mkdir -p "$BACKUP_DIR"
    cd "$BACKUP_DIR"
    dconf read /org/gnome/shell/app-picker-layout > app-picker-layout-value.txt
    # dconf write /org/gnome/shell/app-picker-layout "$(cat app-picker-layout-value.txt)"
    rsync -av "$HOME/.ssh/" ssh/
    rsync -av "$HOME/.config/nix/" nix/
    rsync -av "$HOME/.mozilla/" mozilla/

[group('emacs')]
emacs-ob-tangle:
    emacs -Q --batch \
    -l org \
    --eval '(setq vc-follow-symlinks nil)' \
    --eval '(org-babel-tangle-file "~/.config/emacs/all-emacs.org")'

[group('emacs')]
emacs-ob-tangle-doom:
    emacs -Q --batch \
    -l org \
    --eval '(setq vc-follow-symlinks nil)' \
    --eval '(org-babel-tangle-file "~/.config/doom/config.org")'
