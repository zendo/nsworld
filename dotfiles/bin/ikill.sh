#!/usr/bin/env bash
# ikill.sh - interactively kill running processes (bash + fzf port of pombadev/ikill)
# deps: bash, ps, awk, fzf
set -uo pipefail

VERSION="1.6.0"
SIGNAL="${IKILL_SIGNAL:-KILL}"   # ikill 原版发 SIGKILL；IKILL_SIGNAL=TERM 可改成优雅退出

usage() {
  cat <<'EOF'
ikill - Interactively kill processes

USAGE:
    ikill

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

KEYS:
    <Tab>            multi select
    <Enter>          kill selected processes
    <Ctrl-L>         clear query
    <Esc>            abort

ENV:
    IKILL_SIGNAL     signal to send, default KILL (e.g. TERM)
EOF
}

case "${1-}" in
  "") ;;
  -h|--help) usage; exit 0 ;;
  -V|--version) printf 'ikill v%s\n' "$VERSION"; exit 0 ;;
  *)
    printf "error: Found argument '%s' which wasn't expected\n\nUSAGE:\n    ikill\n\nFor more information try --help\n" "$1" >&2
    exit 1
    ;;
esac

command -v fzf >/dev/null 2>&1 || { echo "ikill: fzf not found in PATH" >&2; exit 1; }

# 每行: PID \t NAME \t COMMAND   (用 tab 分隔，避免命令里带空格导致取错字段)
list_processes() {
  ps -eo pid=,comm=,args= 2>/dev/null | awk '
    NF {
      pid = $1; name = $2
      sub(/^[ \t]*[^ \t]+[ \t]+[^ \t]+[ \t]*/, "", $0)   # 去掉前两列
      printf "%s\t%s\t%s\n", pid, name, $0
    }'
}

selected=$(
  list_processes | fzf \
    --height=70% \
    --reverse \
    --multi \
    --smart-case \
    --header='PID	NAME	COMMAND' \
    --delimiter='\t' \
    --inline-info \
    --preview-window='right:50%' \
    --preview='echo {3}' \
    --bind='ctrl-l:clear-query'
)

# Esc / 空选择：和 ikill 一样直接退出，不杀任何进程
[[ -z $selected ]] && exit 0

failed=0
while IFS=$'\t' read -r pid _; do
  [[ -z $pid ]] && continue
  if kill -s "$SIGNAL" -- "$pid" 2>/dev/null; then
    printf 'killed %s\n' "$pid"
  else
    printf 'ikill: failed to kill %s\n' "$pid" >&2
    failed=1
  fi
done <<< "$selected"

exit "$failed"
