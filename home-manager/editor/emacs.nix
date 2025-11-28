{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vips # dirvish image
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages =
      epkgs: with epkgs; [
        eat
        jinx
        vterm
        emojify
        sqlite3
        # lsp-bridge
        # pdf-tools
        # telega
        # treesit-grammars.with-all-grammars
        (treesit-grammars.with-grammars (
          grammars: with grammars; [
            tree-sitter-bash
            tree-sitter-just
            tree-sitter-json
            tree-sitter-markdown
            tree-sitter-cmake
            tree-sitter-elisp
            tree-sitter-nix
            tree-sitter-cpp
            tree-sitter-python
            tree-sitter-go
            tree-sitter-rust
          ]
        ))
      ];
    extraConfig = ''
      (display-time-mode 1)
      ;; toggle-input-method
      ;; cp ~/nsworld/dotfiles/rime/default.custom.yaml ~/.config/emacs/rime/
      ;; touch ~/.config/emacs/rime/default.yaml
      (setq rime-librime-root "${pkgs.librime}"
            rime-emacs-module-header-root "${pkgs.emacs-pgtk}/include"
            rime-share-data-dir "${pkgs.rime-ice}/share/rime-data")
    '';
  };

  services.emacs = {
    # enable = true;
    client = {
      enable = true;
      arguments = [ "--create-frame" ];
    };
    startWithUserSession = true;
    defaultEditor = true;
  };
}
