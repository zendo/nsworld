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
     \t hmswitch/hmsource/hmdiff/wslswitch
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
        nix run nixpkgs#"$2" -- "$@" ;;

    shell)
        nix shell nixpkgs#"$2" ;;

    search)
        nix search nixpkgs "$2" ;;

    boot)
        sudo nixos-rebuild boot --flake $dotConfig#"$(hostname)" ;;

    switch)
        sudo nixos-rebuild switch --flake $dotConfig#"$(hostname)" ;;

    upgrade)
        sudo nixos-rebuild boot --flake $dotConfig#"$(hostname)" \
            --recreate-lock-file ;;

    wslswitch)
        sudo nixos-rebuild switch --flake $dotConfig#wsl ;;

    hmswitch)
        nix run nixpkgs#home-manager build switch -- \
            --flake $dotConfig#"$(id -u -n)" ;;

    hmsource)
        readlink -f /nix/var/nix/profiles/per-user/"$(id -u -n)"/home-manager ;;

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




# https://github.com/thiagokokada/nix-configs

# readonly program_name="${1:-}"

# if [[ -z "$program_name" ]]; then
#    cat <<EOF
# usage: $(basename "$0") <name>
# Get where in /nix/store a program is located.
# EOF
#     exit 1
# fi

# readlink -f "$(which "$program_name")"


# MISC
# if [ "$UID" -gt 0 ]; then
#      echo "Sorry, this script must be run as ROOT!"
#      exit 1
# fi
# echo "continue script"
