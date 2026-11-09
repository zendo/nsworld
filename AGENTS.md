## What This Is

A NixOS config repo. Flake at the root. Machines in modules/hosts/, packages in pkgs/.

## How to Work Here

- Don't run `nix flake show`.
- Don't run `nixos-rebuild switch/test` without being asked.

## nixpkgs

Use local nixpkgs if you don't need newer ones.

Run: `nix flake metadata nixpkgs --json | jq -r '.path'` to get the path of local nixpkgs in store. Avoid requesting Github over and over again.

## Filesystem searches
    
MUST NOT perform an unbounded recursive filesystem search from `/` or `/nix/store`. Scope `find`, `grep -r`, `rg`, `fd`, etc. to the current project or another explicitly relevant directory.

If a host-wide search really seems necessary, ask user first.

## No `| tail` and `| head` in bash

Do not pipe any command output through `head` or `tail`; tools will properly handle large output natively.

## Writing comments

Code comments are not a changelog. Comments should explain why the code exists, not what was edited.

## Adding a selfhosted service

One file per service in `modules/selfhosted/<name>.nix`; import-tree picks it up automatically.

- 模块里不启用任何东西：全部包进 `config = lib.mkIf config.services.<name>.enable { ... };`
  这个模块也会被不跑该服务的机器导入，注意别漏配置。
- 端口加在 `modules/myvars.nix`（`4CXX` 规则，序号顺延不复用），服务绑 `127.0.0.1:<port>`，
  在 `caddy.nix` 加 `reverse_proxy`，不开防火墙。上游没有监听地址的在注释里写明它固定 `0.0.0.0`。
- 先读上游模块：会删 UI 状态的选项（syncthing `overrideDevices/Folders`）、反代 Host 校验
  （`insecureSkipHostcheck`）、回调地址（`NEXTAUTH_URL`）、只在全新 state 目录跑的一次性
  初始化（influxdb2 `provision.initialSetup`，旧的未初始化库要 wipe）。`dataDir` 只是状态
  目录，不是同步路径白名单。

验证：未 `git add` 的文件用 `builtins.getFlake "path:/home/${id -un}/nsworld"` 评估（`.#` 读 git
快照会忽略它），用 `extendModules` + `mkForce false` 确认禁用时不漏配置；远程部署前先 `git add`。
