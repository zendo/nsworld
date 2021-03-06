;;; lang-main.el --- Main Development languages -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; prog-mode 编程模式设定
(defun my-prog-settings ()
  "My owner my-prog-settings."
  (hl-line-mode)               ;高亮当前行
  (whitespace-mode)            ;显示空格
  (display-line-numbers-mode)) ;显示行号
(add-hook 'prog-mode-hook 'my-prog-settings)

;; conf-mode
(add-to-list 'auto-mode-alist
             '("bashrc\\'" . conf-mode))

;; compilation
(setq compilation-ask-about-save nil  ;Just save before compiling
      compilation-always-kill t       ;kill old compile processes before new one
      compilation-scroll-output 'first-error ; Automatically scroll to first error
      )

;; Markdown
(use-package markdown-mode
  :mode (("\\.md\\'" . gfm-mode)
         ("README\\'" . gfm-mode))
  :config
  (setq markdown-fontify-code-blocks-natively t))

;; SQL
(use-package sql-indent
  :mode "\\.sql\\'"
  :interpreter ("sql" . sql-mode))

;; docker
(use-package dockerfile-mode
  :mode "Dockerfile\\'")

;; toml
(use-package toml-mode
  :mode "\\.toml'")

;; yaml
(use-package yaml-mode
  :mode "\\.yml'")

;; nixos
(use-package nix-mode
  :mode "\\.nix'")

;; lua
(use-package lua-mode
  :mode "\\.lua'")



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Company, fly, yas, lsp ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; corfu
(use-package corfu
  :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect-first nil)    ;; Disable candidate preselection
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-echo-documentation nil) ;; Disable documentation in the echo area
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin
  :hook (prog-mode . corfu-mode)
  :bind (:map corfu-map
              ("<escape>" . corfu-quit))
  :init
  (corfu-global-mode))

;; company
;; (use-package company
;;   :defer t
;;   :diminish company-mode
;;   :hook (prog-mode . company-mode)
;;   :config (setq company-tooltip-align-annotations t)
;;   (setq company-minimum-prefix-length 1)
;;   ;; Trigger completion immediately.
;;   (setq company-idle-delay 0)
;;   ;; Number the candidates (use M-1, M-2 etc to select completions).
;;   (setq company-show-numbers t))

;; (with-eval-after-load 'company
;;     (setq-default company-dabbrev-other-buffers 'all
;;                   company-tooltip-align-annotations t)
;;     (define-key company-mode-map (kbd "C-.") 'company-complete)
;;     (define-key company-mode-map [remap completion-at-point] 'company-complete)
;;     (define-key company-mode-map [remap indent-for-tab-command] 'company-indent-or-complete-common)
;;     (define-key company-active-map (kbd "C-.") 'company-other-backend))

;; tabnine
;; ;; M-x company-tabnine-install-binary
;; (use-package company-tabnine)
;; (add-to-list 'company-backends #'company-tabnine)

;; flycheck
(use-package flycheck
  :defer t
  :diminish flycheck-mode
  :hook (prog-mode . flycheck-mode)
  :config (setq flycheck-emacs-lisp-load-path 'inherit) ;identified my load-path
  )

;; yasnippet
(use-package yasnippet
  :defer t
  :diminish yas-minor-mode
  :init (add-hook 'prog-mode-hook #'yas-minor-mode)
  :config (yas-reload-all))
(use-package yasnippet-snippets
  :after yasnippet
  :config (yasnippet-snippets-initialize))

;; LSP https://emacs-lsp.github.io/lsp-mode/
(use-package lsp-mode
  :hook ((python-mode . lsp-deferred)
         (rust-mode . lsp-deferred))
  :commands (lsp lsp-deferred))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)


;; eglot
;; (use-package eglot)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Rust ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; rustic https://github.com/brotzeit/rustic
(use-package rustic
  :defer t)

;; (use-package rust-mode
;;   :mode "\\.rs\\'"
;;   ;; :hook (rust-mode . lsp)
;;   :config
;;   (setq rust-format-on-save t))

;; (use-package cargo
;;   :defer t
;;   :hook (rust-mode . cargo-minor-mode))

;; (use-package flycheck-rust
;;   :defer t
;;   ;; :config
;;   ;; (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
;;   )
;; (with-eval-after-load 'rust-mode
;;   (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Python ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package python-mode
  :mode "\\.py\\'"
  ;; :hook (python-mode . lsp)
  :config
  (setq python-indent-offset 4
        python-indent 4
        indent-tabs-mode nil
        default-tab-width 4
        python-shell-interpreter "python3"))

;; (use-package lsp-python-ms
;;   :hook (python-mode . (lambda ()
;;                           (require 'lsp-python-ms)
;;                           (lsp))))
                                        ; or lsp-deferred



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Common lisp ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; elisp-mode
;; (defun no-fly-yas()
;;   "No fly anf yas."
;;   (flycheck-mode -1) (yas-minor-mode -1))
;; (add-hook 'emacs-lisp-mode-hook 'no-fly-yas)
(add-hook 'emacs-lisp-mode-hook (lambda () (flycheck-mode -1)) t) ;only flycheck
(add-hook 'emacs-lisp-mode-hook (lambda () (setq mode-name "ξ "))) ;hook for shortname


(provide 'lang-main)
;;; lang-main.el ends here
