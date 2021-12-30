#! /usr/bin/env bash

##################################################################
# ln: make symbolic links
# -s --symbolic            软链接
# -f --force               强制覆盖
# -n --no-dereference
# -T 可以覆盖旧的软链目录，而不会在内部重复套娃
# -v --verbose             冗长显示输出结果
##################################################################

this_dir=$(cd "$(dirname "$0")";pwd) #current dir

ln -sfv "$this_dir"/default.custom.yaml "$HOME"/.config/ibus/rime/default.custom.yaml

ln -sfv "$this_dir"/ibus_rime.yaml "$HOME"/.config/ibus/rime/ibus_rime.yaml

ln -sfv "$this_dir"/luna_pinyin_simp.custom.yaml "$HOME"/.config/ibus/rime/luna_pinyin_simp.custom.yaml

ln -sfv "$this_dir"/luna_pinyin_simp.extended.dict.yaml "$HOME"/.config/ibus/rime/luna_pinyin_simp.extended.dict.yaml
