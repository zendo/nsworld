#!/usr/bin/env bash

set -euo pipefail

function usage() {
    echo "Usage: $0 diff/source/upgrade"
}

if [ $# -eq 0 ]
then
    usage
    exit 0
fi

dotConfig=~/.nsworld

case $1
in
    which)
        readlink -f $(which $2) ;;

    boot)
        sudo -E nixos-rebuild boot --flake $dotConfig#$(hostname) ;;

    switch)
        sudo -E nixos-rebuild switch --flake $dotConfig#$(hostname) ;;

    upgrade)
        sudo -E nixos-rebuild boot --flake $dotConfig#$(hostname) \
            --recreate-lock-file ;;

    hmswitch)
        nix run nixpkgs#home-manager build switch -- \
            --flake $dotConfig#$(users) ;;

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
        nix-store -q --references $(readlink -f $(which $2)) ;;

    depends)
        nix path-info -rsSh $(readlink -f $(which $2)) ;;

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
