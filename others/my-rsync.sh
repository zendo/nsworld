#! /bin/bash

################################################################
# rsync: fast and extraordinarily versatile file copying tool.
# -a --archive        等于-rlptgoD
# -v --verbose        冗长显示输出
# -h --human-readable 人类显示输出
# -p --perms          保持文件权限
# -L --copy-links     拷贝软链实际源文件
################################################################

# -L = Copy Real file for symbol link
rsync -avhpL "$HOME"/Dropbox "$HOME"/Documents/Dropbox_backups
