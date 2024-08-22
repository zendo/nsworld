#! /usr/bin/env bash

##################################################################
# ln: make symbolic links
# -s --symbolic            软链接
# -f --force               强制覆盖
# -n --no-dereference
# -T 可以覆盖旧的软链目录，而不会在内部重复套娃
# -v --verbose             冗长显示输出结果
##################################################################

# this_dir=$(cd "$(dirname "$0")";pwd) #current dir
# this_dir=$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" ) #current dir
this_dir=$( dirname -- "$( readlink -f -- "$0"; )"; ) #current dir

# -e exists
if [[ ! -e "$HOME/.local/share/fcitx5/rime" ]]; then
    mkdir "$HOME/.local/share/fcitx5/rime"
fi

ln -sfv "$this_dir"/default.custom.yaml "$HOME"/.local/share/fcitx5/rime/default.custom.yaml

## rime-ice
ln -sfv "$this_dir"/rime_ice.custom.yaml "$HOME"/.local/share/fcitx5/rime/rime_ice.custom.yaml

# rime-frost
ln -sfv "$this_dir"/rime_frost.custom.yaml "$HOME"/.config/ibus/rime/rime_frost.custom.yaml
