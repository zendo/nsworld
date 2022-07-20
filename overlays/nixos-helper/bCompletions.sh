_ns_completions()
{
#COMPREPLY=($(compgen -W "hmsource hmdiff diff source installed" "${COMP_WORDS[1]}"))
#COMPREPLY=(which run boot switch upgrade hmswitch hmsource hmdiff diff source installed profiles generations references depends fetch-merge run-pr pull-pr index-update)

  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  # suggestions from history
  # local suggestions=($(compgen -W "$(fc -l -50 | sed 's/\t/ /')" -- "${COMP_WORDS[1]}"))

  # suggestions words
  local suggestions=($(compgen -W "which log run shell search boot switch upgrade wslswitch hmswitch hmsource hmdiff diff source installed profiles generations references depends gitfm pr-run pr-shell pr-pull to-sri index-update" -- "${COMP_WORDS[1]}"))

  if [ "${#suggestions[@]}" == "1" ]; then
    # if there's only one match, we remove the command literal
    # to proceed with the automatic completion of the number
    local number=$(echo ${suggestions[0]/%\ */})
    COMPREPLY=("$number")
  else
    # more than one suggestions resolved,
    # respond with the suggestions intact
    COMPREPLY=("${suggestions[@]}")
  fi
}
complete  -F _ns_completions ns




# To use this in zsh, add the following code before running the complete command in your ~/.zshrc:

# # make zsh emulate bash if necessary
# if [[ -n "$ZSH_VERSION" ]]; then
#     autoload bashcompinit
#     bashcompinit
# fi

    # local cur prev opts
    # _get_comp_words_by_ref -n : cur

    # COMPREPLY=()
    # cur="${COMP_WORDS[COMP_CWORD]}"
    # prev="${COMP_WORDS[COMP_CWORD-1]}"
    # opts="$(curl -s cheat.sh/:list)"

    # if [ ${COMP_CWORD} = 1 ]; then
    #   COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    #   __ltrim_colon_completions "$cur"
    # fi
    # return 0


    # local CMDLINE
    # local IFS=$'\n'
    # CMDLINE=(--bash-completion-index $COMP_CWORD)

    # for arg in ${COMP_WORDS[@]}; do
    #     CMDLINE=(${CMDLINE[@]} --bash-completion-word $arg)
    # done

    # COMPREPLY=( $(/nix/store/3055kx6ljcbk06f94rz1camhf8ypsjid-niv-0.2.21-bin/bin/niv "${CMDLINE[@]}") )
