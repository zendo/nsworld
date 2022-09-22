# _ns_cmds() {
#   local -a builtin_cmds=(
#   'init[create a west workspace]'
#   'update[update projects described in west manifest]'
#   'list[print information about projects]'
#   'manifest[manage the west manifest]'
#   'diff["git diff" for one or more projects]'
#   'status["git status" for one or more projects]'
#   'forall[run a command in one or more local projects]'
#   'config[get or set config file values]'
#   'topdir[print the top level directory of the workspace]'
#   'help[get help for west or a command]'
#   )

#   local -a zephyr_ext_cmds=(
#   'completion[display shell completion scripts]'
#   'boards[display information about supported boards]'
#   'build[compile a Zephyr application]'
#   'sign[sign a Zephyr binary for bootloader chain-loading]'
#   'flash[flash and run a binary on a board]'
#   'debug[flash and interactively debug a Zephyr application]'
#   'debugserver[connect to board and launch a debug server]'
#   'attach[interactively debug a board]'
#   'zephyr-export[export Zephyr installation as a CMake config package]'
#   'spdx[create SPDX bill of materials]'
#   'blobs[work with binary blobs]'
#   )

#   local -a all_cmds=(${builtin_cmds} ${zephyr_ext_cmds})

#   if [[ -v NS_COMP_CHECK_WORKSPACE ]]; then
#     west topdir &>/dev/null
#     if [ $? -eq 0 ]; then
#       _values "west command" $all_cmds
#     else
#       _values "west command" $builtin_cmds
#     fi
#   else
#       _values "west command" $all_cmds
#   fi
# }


# Completion script for Zephyr's meta-tool, west
# _west() {


#   # Global options for all commands
#   local -a global_opts=(
#   # (: * -) as exclusion list means exclude everything else
#   '(: * -)'{-h,--help}'[show help]'
#   # An exclusion list with the very option means only allow once
#   {-v,--verbose}'[enable verbosity]'
#   '(: * -)'{-V,--version}'[print version]'
#   '(-z --zephyr-base)'{-z,--zephyr-base}'[zephyr base folder]:zephyr base folder:_directories'
#   )

#   typeset -A opt_args
#   local curcontext="$curcontext" context state state_descr line
#   local -a orig_words

#   orig_words=( ${words[@]} )

#   _arguments -S -C \
#     $global_opts \
#           "1: :->cmds" \
#           "*::arg:->args" \

#   case "$state" in
#   cmds)
#     _west_cmds
#     ;;

#   args)
#     _opt_args=( ${(@kv)opt_args} )
#     _call_function ret _west_$line[1]
#     ;;
#   esac
# }


# don't run the completion function when being source-ed or eval-ed
# if [ "$funcstack[1]" = "_ns" ]; then
#     _ns
# fi
