#! /usr/bin/env bash

################################################################
# rsync: fast and extraordinarily versatile file copying tool.
# -a --archive         等于-rlptgoD
# -v --verbose         冗长显示输出
# -h --human-readable  人类显示输出
# -p --perms           保持文件权限
# -L --copy-links      拷贝软链实际源文件
# -x --one-file-system 不要跨越文件系统边界

# -P                  等同于 --partial--progress 显示备份过程
# -z,                 --compress 对备份的文件在传输时进行压缩处理
# --exclude=PATTERN   指定排除不需要传输的文件模式
# --include=PATTERN   指定不排除而需要传输的文件模式
# --exclude-from=FILE 排除 FILE 中指定模式的文件
# --include-from=FILE 不排除 FILE 指定模式匹配的文件
################################################################

# -L = Copy Real file for symbol link
rsync -avhpL "$HOME"/Dropbox "$HOME"/Documents/Dropbox_backups
