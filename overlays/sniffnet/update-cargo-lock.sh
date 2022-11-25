#!nix-shell
#!nix-shell -i bash -p coreutils gnugrep git cargo

# Copy from pkgs/applications/audio/netease-music-tui/update-cargo-lock.sh

set -eu -o verbose

here=$PWD
version=$(cat < default.nix | grep '^  version = "' | cut -d '"' -f 2)
checkout=$(mktemp -d)
git clone -b "v$version" --depth=1 https://github.com/GyulyVGC/sniffnet "$checkout"
cd "$checkout"

cargo generate-lockfile
git add -f Cargo.lock
git diff HEAD -- Cargo.lock > "$here"/cargo-lock.patch

cd "$here"
rm -rf "$checkout"
