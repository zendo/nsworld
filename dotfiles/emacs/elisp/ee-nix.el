;;; -*- lexical-binding: t; -*-

(use-package direnv
  :after lsp
  :delight 'direnv-mode
  :config
  ;; Ensures that external dependencies are available before they are called.
  (add-hook 'prog-mode-hook #'direnv--maybe-update-environment)
  ;; XXX cargo culted.  Investigate
  (add-to-list 'direnv-non-file-modes 'vterm-mode)
  (setq direnv-always-show-summary nil)
  (direnv-mode 1))

(use-package nix-mode
  :mode ("\\.nix'"))

(use-package nixpkgs-fmt
  :defer t)

(provide 'ee-nix)
;;; ee-nix.el ends here
