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
     \t pr-run/pr-shell/pr-pull/gitfm
     \t hmswitch/hmsource/hmprofiles/hmdiff/wslswitch
     "
}

if [ $# -eq 0 ]
then
    usage
    exit 0
fi

case "$1" in

    which)
        readlink -f "$(which "$2")" ;;

    log)
        nix log "$(ns which "$2")" ;;

    run)
        nix run nixpkgs#"$2" ;;

    run-with)
        nix run nixpkgs#"$2" -- "$@" ;;

    shell)
        nix shell nixpkgs#"$2" ;;

    boot)
        nixos-rebuild boot --use-remote-sudo --flake $dotConfig#"$(hostname)" ;;

    switch)
        nixos-rebuild switch --use-remote-sudo --flake $dotConfig#"$(hostname)" ;;

    upgrade)
        nixos-rebuild boot --use-remote-sudo --flake $dotConfig#"$(hostname)" \
            --recreate-lock-file ;;

    wslswitch)
        nixos-rebuild switch --use-remote-sudo --flake $dotConfig#wsl ;;

    hmswitch)
        nix run nixpkgs#home-manager switch -- \
            --flake $dotConfig#"$(id -u -n)" ;;

    hmsource)
        readlink -f /nix/var/nix/profiles/per-user/"$(id -u -n)"/home-manager ;;

    hmprofiles)
        ls -la /nix/var/nix/profiles/per-user/"$(id -u -n)" ;;

    hmdiff)
        nix profile diff-closures --profile \
            /nix/var/nix/profiles/per-user/"$(id -u -n)"/home-manager ;;

    diff)
        nix profile diff-closures --profile \
            /nix/var/nix/profiles/system ;;

    source)
        readlink -f /nix/var/nix/profiles/system ;;

    installed)
        nix path-info --recursive /run/current-system ;;

    profiles)
        ls -la /nix/var/nix/profiles ;;

    generations)
        nix profile history --profile /nix/var/nix/profiles/system ;;

    references)
        nix-store -q --references "$(readlink -f "$(which "$2")")" ;;

    depends)
        nix path-info -rsSh "$(readlink -f "$(which "$2")")" ;;

    gitfm)
        git fetch upstream master && git merge "$(nixos-version --revision)" ;;

    pr-run)
        nix run github:NixOS/nixpkgs/pull/"$2"/merge#"$3" ;;

    pr-shell)
        nix shell github:NixOS/nixpkgs/pull/"$2"/merge#"$3" ;;

    pr-pull)
        gh pr checkout -R NixOS/nixpkgs "$2" ;;

    to-sri)
        nix hash to-sri --type sha256 "$2" ;;

    index-update)
        filename="index-x86_64-$(uname | tr '[:upper:]' '[:lower:]')"
        mkdir -p ~/.cache/nix-index
        pushd ~/.cache/nix-index > /dev/null
        wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/"$filename"
        ln -f "$filename" files
        popd > /dev/null ;;

    *) echo "Nothing to do"
       exit ;;

esac
