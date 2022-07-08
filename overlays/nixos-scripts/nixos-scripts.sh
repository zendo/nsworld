#!/usr/bin/env bash

# https://github.com/thiagokokada/nix-configs

set -euo pipefail

readonly program_name="${1:-}"

if [[ -z "$program_name" ]]; then
   cat <<EOF
usage: $(basename "$0") <name>
Get where in /nix/store a program is located.
EOF
    exit 1
fi

readlink -f "$(which "$program_name")"

# howto write shell script
# f() {
#   if [[ $@ == "diff" || $@ == "console" ]]; then
#     nix profile diff-closures --profile /nix/var/nix/profiles/system
#   elif [[ $@ == "installed" || $@ == "server" ]]; then
#     nix path-info --recursive /run/current-system
#   elif [[ $@ == "source" || $@ == "routes" ]]; then
#     readlink -f /nix/var/nix/profiles/system
#   fi
# }; f
