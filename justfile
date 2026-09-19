set shell := ["bash", "-uc"]

host := `uname -n`
user := `id -un`
home_dir := env_var('HOME')

_elevate := if `command -v run0 2>/dev/null` != "" { "--elevate=run0" } else { "--elevate=sudo" }

[private]
_default:
    @just --choose --unsorted

# j os build/switch/boot/test |& nom --install-bootloader
os *args:
    nixos-rebuild {{ _elevate }} --flake .\#"{{ host }}" {{ args }}

# nix store diff-closures /run/current-system ./result
# j os build ; dix /run/current-system ~/nsworld/result
diff:
    nix profile diff-closures --profile /nix/var/nix/profiles/system

diff-dix:
    dix $(\ls -dv /nix/var/nix/profiles/system-*-link | tail -2)

diff-commit:
    git commit --allow-empty -m "📦 host.{{ host }}: Update details" \
        -m "$(just diff-dix | tail -n +3)"

gca:
    nix-collect-garbage -d ; sudo nix-collect-garbage -d ; sudo /run/current-system/bin/switch-to-configuration boot

up:
    #!/usr/bin/env bash
    get_rev() {
        nix eval --raw .\#nixosConfigurations."{{ host }}".config.system.nixos.revision
    }
    before=$(get_rev)
    nix flake update --commit-lock-file
    after=$(get_rev)
    if [[ "$before" == "$after" ]]; then
        echo -e "\n✅ Nixpkgs is already up to date."
    else
        url="https://github.com/NixOS/nixpkgs/compare/${before:0:12}...${after:0:12}"
        echo -e "\n🔍 Nixpkgs Comparing changes: $url"
        git commit --amend --quiet \
            -m "🚀 $(git log -1 --pretty=%B)" \
            -m "🔍 Nixpkgs Comparing changes: $url"
    fi

backup-my-data:
    #!/usr/bin/env bash
    BACKUP_DIR="$HOME/Documents/mybackup"
    mkdir -p "$BACKUP_DIR"
    cd "$BACKUP_DIR"
    dconf read /org/gnome/shell/app-picker-layout > app-picker-layout-value.txt
    # dconf write /org/gnome/shell/app-picker-layout "$(cat app-picker-layout-value.txt)"
    rsync -av "$HOME/.zsh_history" .
    rsync -av "$HOME/.ssh/" ssh/
    rsync -av "$HOME/.config/mozilla/" mozilla/

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
