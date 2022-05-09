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

if [[ ! -e "$HOME/.local/share/fcitx5/rime" ]]; then
    mkdir "$HOME/.local/share/fcitx5/rime"
fi

ln -sfv "$this_dir"/default.custom.yaml "$HOME"/.local/share/fcitx5/rime/default.custom.yaml
ln -sfv "$this_dir"/luna_pinyin_simp.custom.yaml "$HOME"/.local/share/fcitx5/rime/luna_pinyin_simp.custom.yaml
ln -sfv "$this_dir"/luna_pinyin_simp.extended.dict.yaml "$HOME"/.local/share/fcitx5/rime/luna_pinyin_simp.extended.dict.yaml
