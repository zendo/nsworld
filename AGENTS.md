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
