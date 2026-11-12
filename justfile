set shell := ["bash", "-uc"]
# set quiet

host := `uname -n`
user := `id -un`
home_dir := env_var('HOME')

[private]
_default:
    @just --choose --unsorted

# j os build/switch/boot/test --install-bootloader
os *args:
    nixos-rebuild \
      --sudo \
      --flake .\#"{{ host }}" \
      --log-format internal-json \
      {{ args }} 2>&1 | rom && \
      dix last

diff:
    nix profile diff-closures --profile /nix/var/nix/profiles/system

gca:
    nix-collect-garbage -d ; sudo nix-collect-garbage -d ; \
    sudo /run/current-system/bin/switch-to-configuration boot

up:
    #!/usr/bin/env bash
    get_rev() {
        jq -r '.nodes[.nodes.root.inputs.nixpkgs].locked.rev' flake.lock
    }
    before=$(get_rev)
    nix flake update --commit-lock-file
    after=$(get_rev)
    if [[ "$before" == "$after" ]]; then
        echo -e "\n✅ Nixpkgs is already up to date."
    else
        url="https://diffshub.com/NixOS/nixpkgs/compare/${before:0:12}...${after:0:12}"
        echo -e "\n🔍 Nixpkgs Comparing changes: $url"
        git commit --amend --quiet \
            -m "🚀 $(git log -1 --pretty=%B)" \
            -m "🔍 Nixpkgs Comparing changes: $url"
    fi

commit-dix:
    git commit --allow-empty -m "📦 host.{{ host }}: Update details" \
        -m "$(dix last)"

[group('selfhosted')]
selfhosted-domains:
    #!/usr/bin/env bash
    set -euo pipefail
    cfg=.\#"nixosConfigurations.svp.config"
    nix eval --json "$cfg" --apply '
      c: builtins.attrNames c.services.caddy.virtualHosts' \
      | jq -r 'map(sub("^https?://"; "")) | map(select(test("^[A-Za-z0-9.-]+$"))) | sort | .[], "192.168.2.99"' \
      | paste -sd'/' - \
      | sed 's|^|/|'

[group('emacs')]
emacs-ob-tangle:
    emacs -Q --batch \
      -l org \
      --eval '(setq vc-follow-symlinks nil)' \
      --eval '(org-babel-tangle-file "~/.config/emacs/all-emacs.org")'

[group('emacs')]
emacs-ob-tangle-doom:
    emacs -Q --batch \
      -l org \
      --eval '(setq vc-follow-symlinks nil)' \
      --eval '(org-babel-tangle-file "~/.config/doom/config.org")'

[group('desktop')]
gnome-reset-dconf:
    #!/usr/bin/env bash
    set -euo pipefail
    # kde-gtk-config（系统设置 → 应用程序风格 → GTK 应用外观）会把这些键写成
    # Breeze，切回 GNOME 后鼠标/图标/字体就错乱。reset 掉用户值，让系统级 dconf
    # profile 里声明的值（Adwaita 等）重新生效。
    # 用 dconf 而不是 gsettings：KDE 会话里 gsettings 不在 PATH，且它需要 schema。
    keys=(
      /org/gnome/desktop/interface/cursor-theme
      /org/gnome/desktop/interface/icon-theme
      /org/gnome/desktop/interface/font-name
      /org/gnome/desktop/interface/document-font-name
      /org/gnome/desktop/interface/monospace-font-name
      /org/gnome/desktop/peripherals/mouse/cursor-size
      /org/gnome/desktop/sound/theme-name
      /org/gnome/desktop/wm/preferences/button-layout
    )
    for k in "${keys[@]}"; do
      dconf reset "$k" 2>/dev/null || true
    done
    for k in "${keys[@]}"; do
      v=$(dconf read "$k" 2>/dev/null || true)
      printf '%-22s %s\n' "${k##*/}" "${v:-（空 = 用系统默认）}"
    done
