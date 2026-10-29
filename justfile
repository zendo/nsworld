set shell := ["bash", "-uc"]
# set quiet

host := `uname -n`
user := `id -un`
home_dir := env_var('HOME')

[private]
_default:
    @just --choose --unsorted

# j os build/switch/boot/test |& nom --install-bootloader
os *args:
    nixos-rebuild --sudo --flake .\#"{{ host }}" {{ args }} && \
    dix last

diff:
    nix profile diff-closures --profile /nix/var/nix/profiles/system

gca:
    nix-collect-garbage -d ; sudo nix-collect-garbage -d ; \
    sudo /run/current-system/bin/switch-to-configuration boot

up:
    #!/usr/bin/env bash
    get_rev() {
        jq -r '.nodes[.nodes.root.inputs.nixpkgs].locked.rev' flake.lock
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

commit-dix:
    git commit --allow-empty -m "📦 host.{{ host }}: Update details" \
        -m "$(dix last)"

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
