#compdef ns

local curcontext="$curcontext" state line  ret=1

typeset -A opt_args

# local -a _1st_arguments
# _1st_arguments=(
#     'wslswitch' 'hmswitch' 'hmsource'
#     # which run shell search boot switch upgrade 'wslswitcch' 'hmswitch' 'hmsource' hmdiff diff source installed profiles 'generations' references depends fetch-merge pr-run pr-pull index-update
# )


_arguments -C \
    'wslswitch' 'hmswitch' 'hmsource' && ret=0

# _arguments -C \
#     '(-h --help)'{-h,--help}'[output usage information]'\
#     '(-V --version)'{-V,--version}'[output the version number]'\
#     '(-o --out)'{-o,--out}'[where to output the rendered directory or files]:path:_files'\
#     '(-c --config)'{-c,--config}'[a custom configuration file to load in]:path:_files'\
#     '(-e --env)'{-e,--env}'[the environment name to use for this instance, multiple names can be separated with a comma]'\
#     '(-d --debug)'{-d,--debug}'+[the level of debug messages you would like to display, if specified defaults to 7, otherwise 6]:number'\
#     '(-f --force)'{-f,--force}'[force a re-install of all modules]'\
#     '1: :->cmds'\
#     '*: :_files'&& ret=0

# case $state in
#     subcmds)
#         _describe -t commands "ns" _1st_arguments && ret=0
#         ;;
# esac

return ret
