function __fish_ns_global_optspecs
    string join \n flake= diff h/help V/version
end

function __fish_ns_needs_command
    # Figure out if the current invocation already has a command.
    set -l cmd (commandline -opc)
    set -e cmd[1]
    argparse -s (__fish_ns_global_optspecs) -- $cmd 2>/dev/null
    or return
    if set -q argv[1]
        # Also print the command, so this can be used to figure out what it is.
        echo $argv[1]
        return 1
    end
    return 0
end

complete -f -c ns -n "__fish_ns_needs_command" -a "boot"
complete -f -c ns -n "__fish_ns_needs_command" -a "switch"
complete -f -c ns -n "__fish_ns_needs_command" -a "upgrade"
complete -f -c ns -n "__fish_ns_needs_command" -a "hmswitch"
complete -f -c ns -n "__fish_ns_needs_command" -a "hmsource"
complete -f -c ns -n "__fish_ns_needs_command" -a "hmprofiles"
complete -f -c ns -n "__fish_ns_needs_command" -a "hmdiff"
complete -f -c ns -n "__fish_ns_needs_command" -a "diff"
complete -f -c ns -n "__fish_ns_needs_command" -a "diff-commits"
complete -f -c ns -n "__fish_ns_needs_command" -a "os-source"
complete -f -c ns -n "__fish_ns_needs_command" -a "os-installed"
complete -f -c ns -n "__fish_ns_needs_command" -a "os-profiles"
complete -f -c ns -n "__fish_ns_needs_command" -a "os-generations"
complete -f -c ns -n "__fish_ns_needs_command" -a "git-sync-nixosVersion"
complete -f -c ns -n "__fish_ns_needs_command" -a "pr-pull"
complete -f -c ns -n "__fish_ns_needs_command" -a "pr-build"
complete -f -c ns -n "__fish_ns_needs_command" -a "hash2sri"
complete -f -c ns -n "__fish_ns_needs_command" -a "indexdb-update"








# complete -c flake-edit -n "__fish_flake_edit_needs_command" -l flake -d 'Location of the `flake.nix` file, that will be used' -r
# complete -c flake-edit -n "__fish_flake_edit_needs_command" -l diff -d 'Print a diff of the changes, will not write the changes to disk'
# complete -c flake-edit -n "__fish_flake_edit_needs_command" -s h -l help -d 'Print help'
# complete -c flake-edit -n "__fish_flake_edit_needs_command" -s V -l version -d 'Print version'
# complete -c flake-edit -n "__fish_flake_edit_needs_command" -f -a "add" -d 'Add a new flake reference'
# complete -c flake-edit -n "__fish_flake_edit_needs_command" -f -a "remove" -d 'Remove a specific flake reference based on its id'
# complete -c flake-edit -n "__fish_flake_edit_needs_command" -f -a "list" -d 'List flake inputs'
# complete -c flake-edit -n "__fish_flake_edit_needs_command" -f -a "update" -d 'Update inputs to their latest specified release'

# -s 后接短选项，类似-v形式
# -l 后接长选项，类似--verbose形式
# --description 是选项的解释，可有可无
