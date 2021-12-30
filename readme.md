# Installtion

nixos-install --root /mnt --flake ~/dotworld/#yoga --impure 
--option substituters "https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org"

# Hardware

ext4 option "noatime" "nodiratime"
btrfs option "compress=zstd" "autodefrag" "noatime"

# Home-manager Setup

nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Desktop Setup

LC_ALL=C xdg-user-dirs-update --force

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub


