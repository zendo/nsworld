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
if [[ ! -e "$HOME/.config/ibus/rime" ]]; then
    mkdir "$HOME/.config/ibus/rime"
fi

ln -sfv "$this_dir"/default.custom.yaml "$HOME"/.config/ibus/rime/default.custom.yaml
ln -sfv "$this_dir"/ibus_rime.custom.yaml "$HOME"/.config/ibus/rime/ibus_rime.custom.yaml

# rime-ice
ln -sfv "$this_dir"/rime_ice.custom.yaml "$HOME"/.config/ibus/rime/rime_ice.custom.yaml

# rime-frost
ln -sfv "$this_dir"/rime_frost.custom.yaml "$HOME"/.config/ibus/rime/rime_frost.custom.yaml
