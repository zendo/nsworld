#!/usr/bin/env python3
"""ikill.py - interactively kill running processes (python + fzf port of pombadev/ikill)

依赖: python3 (仅标准库) + fzf
用法: ./ikill.py [-h|-V]
环境变量: IKILL_SIGNAL=TERM  (默认 KILL，和原版 ikill 一致)
"""

import os
import shutil
import signal
import subprocess
import sys

VERSION = "1.6.0"
SIGNAL = getattr(signal, "SIG" + os.environ.get("IKILL_SIGNAL", "KILL").upper(), signal.SIGKILL)

USAGE = """ikill - Interactively kill processes

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
"""


def processes():
    """产出 (pid, name, cmdline)。直接读 /proc，没有 comm 15 字符截断、不依赖 awk 取字段。"""
    for entry in os.listdir("/proc"):
        if not entry.isdigit():
            continue
        base = "/proc/" + entry
        try:
            with open(base + "/stat") as f:
                state = f.read().rsplit(") ", 1)[1][0]        # comm 里可能有空格，从右括号后取
            if state in "ZX":                                  # 僵尸/已死：杀掉无意义
                continue
            with open(base + "/comm") as f:
                name = f.read().strip()
            with open(base + "/cmdline", "rb") as f:
                cmd = f.read().replace(b"\0", b" ").decode(errors="replace").strip()
        except (OSError, IndexError):
            continue                                           # 读的瞬间退出了，跳过
        yield int(entry), name, cmd or f"[{name}]"              # 内核线程 cmdline 为空


def choose(rows):
    """把列表丢给 fzf，回传选中的 pid 列表（Esc/空选择 -> []）。"""
    argv = [
        "fzf", "--height=70%", "--reverse", "--multi", "--smart-case",
        "--header=PID\tNAME\tCOMMAND", "--delimiter=\t", "--inline-info",
        "--preview-window=right:50%", "--preview=echo {3}", "--bind=ctrl-l:clear-query",
    ]
    listing = "".join(f"{pid}\t{name}\t{cmd}\n" for pid, name, cmd in rows)
    out = subprocess.run(argv, input=listing, capture_output=True, text=True).stdout
    return [int(line.split("\t", 1)[0]) for line in out.splitlines() if line.strip()]


def main():
    args = sys.argv[1:]
    if args and args[0] in ("-h", "--help"):
        print(USAGE, end="")
        return 0
    if args and args[0] in ("-V", "--version"):
        print(f"ikill v{VERSION}")
        return 0
    if args:
        print(f"error: Found argument '{args[0]}' which wasn't expected\n\n"
              f"USAGE:\n    ikill\n\nFor more information try --help", file=sys.stderr)
        return 1
    if not shutil.which("fzf"):
        print("ikill: fzf not found in PATH", file=sys.stderr)
        return 1

    rows = list(processes())
    pids = choose(rows)
    if not pids:
        return 0

    failed = 0
    for pid in pids:
        try:
            os.kill(pid, SIGNAL)
            print(f"killed {pid}")
        except OSError as e:
            print(f"ikill: failed to kill {pid}: {e.strerror}", file=sys.stderr)
            failed = 1
    return failed


if __name__ == "__main__":
    sys.exit(main())
