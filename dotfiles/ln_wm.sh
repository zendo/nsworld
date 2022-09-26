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


ln -sfv "$this_dir"/hypr "$HOME"/.config
ln -sfv "$this_dir"/wofi "$HOME"/.config
ln -sfv "$this_dir"/waybar "$HOME"/.config
ln -sfv "$this_dir"/mako "$HOME"/.config
ln -sfv "$this_dir"/sway "$HOME"/.config
ln -sfv "$this_dir"/swaylock "$HOME"/.config
