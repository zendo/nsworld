{
  perSystem =
    { pkgs, ... }:
    {
      packages.wrapper-emacs = (
        (pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (
          epkgs: with epkgs; [
            jinx
            sqlite3
            # ghostel
            # vterm
            # lsp-bridge
            # pdf-tools
            # telega
            # treesit-grammars.with-all-grammars
            (treesit-grammars.with-grammars (
              grammars: with grammars; [
                tree-sitter-nix
                tree-sitter-elisp
                tree-sitter-bash
                tree-sitter-json
                tree-sitter-json5
                tree-sitter-javascript
                tree-sitter-tsx
                tree-sitter-yaml
                tree-sitter-toml
                tree-sitter-kdl
                tree-sitter-markdown
                tree-sitter-lua
                tree-sitter-go
                tree-sitter-rust
                tree-sitter-python
              ]
            ))
            # (trivialBuild {
            #   pname = "default";
            #   src = pkgs.writeText "default.el" ''
            #     (display-time-mode 1)
            #     ;; toggle-input-method
            #     ;; cp ~/nsworld/dotfiles/rime/default.custom.yaml ~/.config/emacs/rime/
            #     ;; touch ~/.config/emacs/rime/default.yaml
            #     (setq rime-librime-root "${pkgs.librime}"
            #           rime-emacs-module-header-root "${pkgs.emacs-pgtk}/include"
            #           rime-share-data-dir "${pkgs.rime-ice}/share/rime-data")
            #   '';
            #   version = "1.0.0";
            #   # packageRequires = [
            #   #   librime
            #   # ];
            # })
          ]
        )
      );
    };
}
