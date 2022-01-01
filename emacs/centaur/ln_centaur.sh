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

# Emacs
if [[ ! -e "$HOME/.emacs.d" ]]; then
    mkdir "$HOME/.emacs.d"
fi
ln -sfTv "$this_dir"/custom.el "$HOME"/.emacs.d/custom.el
ln -sfv "$this_dir"/custom-post.el "$HOME"/.emacs.d/custom-post.el
