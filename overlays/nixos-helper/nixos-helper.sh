#!/usr/bin/env bash

set -euo pipefail

# variables
dotConfig=~/nsworld

usage() {
    printf "\n Usage:
     \t which/log/references/depends
     \t boot/switch/upgrade/diff
     \t run/search/shell/index-up
     \t profiles/generations/source/installed
     \t pr-run/pr-shell/pr-pull/git-fm
     \t hmswitch/hmsource/hmprofiles/hmdiff
     "
}

if [ $# -eq 0 ]
then
    usage
    exit 0
fi

while [[ $# -gt 0 ]]; do
    case "$1" in

        which)
            readlink -f "$(which "$2")"
            shift ;;

        log)
            nix log "$(ns which "$2")"
            shift ;;

        run)
            nix run nixpkgs#"$2"
            shift ;;

        run-impure)
            NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#"$2" --impure
            shift ;;

        shell)
            nix shell nixpkgs#"$2"
            shift ;;

        shell-impure)
            NIXPKGS_ALLOW_UNFREE=1 nix shell nixpkgs#"$2" --impure
            shift ;;

        boot)
            nixos-rebuild boot --use-remote-sudo --flake $dotConfig#"$(hostname)"
            shift ;;

        switch)
            nixos-rebuild switch --use-remote-sudo --flake $dotConfig#"$(hostname)"
            shift ;;

        upgrade)
            nixos-rebuild boot --use-remote-sudo --flake $dotConfig#"$(hostname)" \
                --recreate-lock-file
            shift ;;

        hmswitch)
            nix run nixpkgs#home-manager switch -- \
                --flake $dotConfig#"$(id -u -n)"
            shift ;;

        hmsource)
            readlink -f /nix/var/nix/profiles/per-user/"$(id -u -n)"/home-manager
            shift ;;

        hmprofiles)
            ls -la /nix/var/nix/profiles/per-user/"$(id -u -n)"
            shift ;;

        hmdiff)
            nix profile diff-closures --profile \
                /nix/var/nix/profiles/per-user/"$(id -u -n)"/home-manager
            shift ;;

        diff)
            nix profile diff-closures --profile \
                /nix/var/nix/profiles/system
            shift ;;

        source)
            readlink -f /nix/var/nix/profiles/system
            shift ;;

        installed)
            nix path-info --recursive /run/current-system
            shift ;;

        profiles)
            ls -la /nix/var/nix/profiles
            shift ;;

        generations)
            nix profile history --profile /nix/var/nix/profiles/system
            shift ;;

        references)
            nix-store -q --references "$(readlink -f "$(which "$2")")"
            shift ;;

        depends)
            nix path-info -rsSh "$(readlink -f "$(which "$2")")"
            shift ;;

        git-fm)
            git fetch upstream master && git merge "$(nixos-version --revision)"
            shift ;;

        pr-run)
            nix run github:NixOS/nixpkgs/pull/"$2"/merge#"$3"
            shift ;;

        pr-shell)
            nix shell github:NixOS/nixpkgs/pull/"$2"/merge#"$3"
            shift ;;

        pr-pull)
            gh pr checkout -R NixOS/nixpkgs "$2"
            shift ;;

        to-sri)
            nix hash to-sri --type sha256 "$2"
            shift ;;

        index-update)
            filename="index-x86_64-$(uname | tr '[:upper:]' '[:lower:]')"
            mkdir -p ~/.cache/nix-index
            pushd ~/.cache/nix-index > /dev/null
            wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/"$filename"
            ln -f "$filename" files
            popd > /dev/null
            shift ;;

        *)
           shift ;;

    esac
done
