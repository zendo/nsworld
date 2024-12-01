;;; ee-prog.el --- Main Development languages -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; prog-mode 编程模式设定
(defun my-prog-settings ()
  "My owner my-prog-settings."
  (hl-line-mode)               ;高亮当前行
  (whitespace-mode)            ;显示空格
  (display-line-numbers-mode)) ;显示行号
(add-hook 'prog-mode-hook 'my-prog-settings)

;; Compilation
(setq compilation-ask-about-save nil  ;Just save before compiling
      compilation-always-kill t       ;kill old compile processes before new one
      compilation-scroll-output 'first-error ; Automatically scroll to first error
      )

(editorconfig-mode t)

(use-package indent-bars
  :defer t)

(use-package quickrun
  :defer t)

(use-package reformatter
  :defer t
  :config
  (reformatter-define nixfmt
    :program "nixfmt"
    )
  ;; Experimental.
  ;; (reformatter-define golint
  ;;   :program "golint"
  ;;   :stdin nil
  ;;   :stdout nil
  ;;   :args (list (buffer-file-name)))
  )

;; tree-sitter
(use-package treesit-auto
  :when (eq system-type 'gnu/linux)
  :config
  (global-treesit-auto-mode))

(use-package list-environment
  :commands (list-environment))

;; conf-mode
(use-package conf-mode
  :mode
  "/credentials$" "\\.accept_keywords$"
  "\\lfrc$" "\\.keywords$" "\\.license$"
  "\\.mask$" "\\.unmask$" "\\.use$")
(global-set-key [remap conf-space-keywords] #'project-find-file)

;; Markdown
(use-package markdown-mode
  :config
  (setq markdown-hide-urls nil
        markdown-fontify-code-blocks-natively t)
  :mode (("\\.md\\'" . gfm-mode)
         ("README\\'" . gfm-mode)))
(use-package markdown-preview-mode
  :defer t)

;; SQL
(use-package sql-indent
  :mode ("\\.sql\\'")
  :interpreter (("sql" . sql-mode)))

;; powershell
(use-package powershell
  :mode ("\\.ps1'"))

;; docker
(use-package dockerfile-mode
  :mode ("Dockerfile\\'"))

;; json
(use-package json-mode
  :mode ("\\.json'"))

(use-package json-reformat
  :commands json-reformat-region)

;; toml
(use-package toml-mode
  :mode ("\\.toml'"))

;; yaml
(use-package yaml-mode
  :mode ("\\.yml'" "\\.yaml'"))

;; lua
(use-package lua-mode
  :mode ("\\.lua'"))

(use-package license-templates
  :defer t)

;; just
(use-package just-mode
  :mode ("\\.just'" "justfile\\'"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; rustic https://github.com/brotzeit/rustic
(use-package rustic
  :mode "\\.rs$"
  :custom
  (rustic-format-display-method 'ignore) ; Rustfmtのメッセージをポップアップしない
  (rustic-format-trigger 'on-save)
  :after flycheck
  :config
  (push 'rustic-clippy flycheck-checkers))

;; (use-package cargo
;;   :defer t
;;   :hook (rust-mode . cargo-minor-mode))

;; (use-package go-mode
;;   :commands go-mode
;;   :config
;;   (setq gofmt-command "goimports")
;;   (add-hook 'before-save-hook 'gofmt-before-save))

(use-package python-mode
  :mode ("\\.py\\'")
  :config
  (setq python-indent-offset 4
        python-indent 4
        indent-tabs-mode nil
        default-tab-width 4
        python-shell-interpreter "python3"))

;; (use-package live-py-mode)

;; (use-package lsp-python-ms
;;   :hook (python-mode . (lambda ()
;;                           (require 'lsp-python-ms)
;;                           (lsp))))
                                        ; or lsp-deferred

;;; Ruby
;; (use-package ruby-mode
;;   :defvar ruby-mode-map
;;   :custom (ruby-insert-encoding-magic-comment . nil)
;;   :hook (ruby-mode-hook . lsp)
;;   :config
;;   (dvorak-set-key-prog ruby-mode-map)
;;   (use-package inf-ruby
;;     :hook (ruby-mode-hook . inf-ruby-minor-mode)))

(use-package elisp-mode
  :ensure nil
  :hook (emacs-lisp-mode . (lambda () (setq mode-name "ξ ")))
  ;; :bind (:map emacs-lisp-mode-map
  ;;             ("C-c e" . fc-eval-and-replace))
  )

(use-package slime
  :commands (slime))

(use-package macrostep
  :bind (:map emacs-lisp-mode-map
         ("C-c e" . macrostep-expand)
         :map lisp-interaction-mode-map
         ("C-c e" . macrostep-expand)))


(provide 'ee-prog)
;;; init-main.el ends here
