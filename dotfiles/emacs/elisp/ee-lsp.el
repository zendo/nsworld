;;; ee-lsp.el --- Main Development languages -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; flycheck
(use-package flycheck
  :defer t
  :diminish " ✓"
  :hook (prog-mode . flycheck-mode)
  :init
  (setq flycheck-disabled-checkers '(
                                     emacs-lisp
                                     emacs-lisp-checkdoc
                                     ;; sh-shellscript
                                     )))

;; tempel
;; (use-package tempel
;;   :bind (("M-+" . tempel-complete)
;;          ("M-*" . tempel-insert)
;;          :map tempel-map
;;          ("M-]" . tempel-next)
;;          ("M-[" . tempel-previous)))

;; yasnippet
;; (use-package yasnippet
;;   :defer t
;;   :custom
;;   (yas-prompt-functions '(yas-completing-prompt))
;;   :config
;;   (yas-reload-all)
;;   :hook
;;   ((prog-mode feature-mode)  . yas-minor-mode))

;; company http://company-mode.github.io/manual/Getting-Started.html
(use-package company
  :disabled t
  :diminish " ▶"
  :init
  (global-company-mode)
  :bind (:map company-active-map
              ("<escape>" . company-abort))
  :config
  (setq company-global-modes '(not eshell-mode gud-mode))
  (setq company-clang-insert-arguments t)
  (setq company-dabbrev-downcase nil)
  (setq company-dabbrev-ignore-case nil)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t)
  (setq company-idle-delay 0))

(use-package company-flx
  :after company
  :init
  (company-flx-mode))

;; corfu https://github.com/minad/corfu
(use-package corfu
  ;; :disabled t
  :bind
  (:map corfu-map
        ("<escape>" . corfu-quit)
        ;; ("<tab>" . corfu-next)
        ("M-d" . corfu-info-documentation)
        ("M-l" . corfu-info-location))
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.0)
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-quit-at-boundary 'separator)   ;; completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin
  (corfu-max-width 110)
  (corfu-preview-current nil)
  (corfu-echo-documentation t)
  :init
  (global-corfu-mode)
  (corfu-history-mode) ; save completion history for better sorting
  ;; (corfu-popupinfo-mode) ; Popup completion info
  :config
  (add-hook 'eshell-mode-hook
            (lambda () (setq-local corfu-quit-at-boundary t
                               corfu-quit-no-match t
                               corfu-auto nil)
              (corfu-mode))))


;; Corfu backend
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-tex)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-symbol)
  (add-to-list 'completion-at-point-functions #'cape-ispell)
  ;; (add-to-list 'completion-at-point-functions #'cape-dict)
  ;; (add-to-list 'completion-at-point-functions #'cape-line)
  (add-to-list 'completion-at-point-functions #'cape-abbrev)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-dabbrev 90)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-hook 'completion-at-point-functions
                        #'cape-keyword nil t))))

;; Pretty icons for corfu
(use-package kind-icon
  :if (display-graphic-p)
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; eglot
(use-package eglot
  :when (eq system-type 'gnu/linux)
  :defer t
  :custom
  (eglot-autoshutdown t) ; shutdown after closing the last managed buffer
  (eglot-sync-connect 0) ; async, do not block
  (eglot-extend-to-xref t) ; can be interesting!
  ;; (eglot-ignored-server-capabilities
  ;;  '(:hoverProvider
  ;;    :documentHighlightProvider
  ;;    :documentFormattingProvider
  ;;    :documentRangeFormattingProvider
  ;;    :documentOnTypeFormattingProvider
  ;;    :colorProvider
  ;;    :foldingRangeProvider))
  :hook (
         (c-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         (go-mode . eglot-ensure)
         (python-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (nix-mode . eglot-ensure)
         (markdown-mode . eglot-ensure)
         )
  :config
  (add-to-list 'eglot-server-programs '(c-mode . ("clangd")))
  (add-to-list 'eglot-server-programs '(c++-mode . ("clangd")))
  (add-to-list 'eglot-server-programs '(go-mode . ("gopls")))
  (add-to-list 'eglot-server-programs '(python-mode . ("pyls")))
  (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '(nix-mode . ("nixd")))
  (add-to-list 'eglot-server-programs '(markdown-mode . ("efm-langserver")))
  )

;; lsp-bridge
;; (use-package lsp-bridge
;;   :ensure nil
;;   :config
;;   (global-lsp-bridge-mode))


;; lsp-mode https://github.com/kira-bruneau/home-config/blob/main/package/emacs/config/setup/minor-modes/lsp.el
;; (use-package lsp-mode
;;   :commands lsp-deferred lsp
;;   :hook ((python-mode-hook . lsp-deferred)
;;          (rust-mode-hook . lsp-deferred)))

;; (use-package lsp-ui
;;   :commands lsp-ui-mode)
;; (use-package lsp-ivy
;;   :commands lsp-ivy-workspace-symbol)

;; (use-package consult-lsp
;;   :package t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package lsp-mode
;;   :require t
;;   :commands lsp
;;   :hook
;;   (go-mode-hook . lsp)
;;   (web-mode-hook . lsp)
;;   (elixir-mode-hook . lsp)
;;   (typescript-mode-hook . lsp)
;;   :config
;;   (use-package lsp-ui
;;     :require t
;;     :hook
;;     (lsp-mode-hook . lsp-ui-mode)
;;     :custom
;;     (lsp-ui-sideline-enable . nil)
;;     (lsp-prefer-flymake . nil)
;;     (lsp-print-performance . t)
;;     :config
;;     (define-key lsp-ui-mode-map [remap xref-find-definitions] 'lsp-ui-peek-find-definitions)
;;     (define-key lsp-ui-mode-map [remap xref-find-references] 'lsp-ui-peek-find-references)
;;     (define-key lsp-ui-mode-map (kbd "C-c i") 'lsp-ui-imenu)
;;     (define-key lsp-ui-mode-map (kbd "s-l") 'hydra-lsp/body)
;;     (setq lsp-ui-doc-position 'bottom)
;;     :hydra (hydra-lsp (:exit t :hint nil)
;;                       "
;;  Buffer^^               Server^^                   Symbol
;; -------------------------------------------------------------------------------------
;;  [_f_] format           [_M-r_] restart            [_d_] declaration  [_i_] implementation  [_o_] documentation
;;  [_m_] imenu            [_S_]   shutdown           [_D_] definition   [_t_] type            [_r_] rename
;;  [_x_] execute action   [_M-s_] describe session   [_R_] references   [_s_] signature"
;;                       ("d" lsp-find-declaration)
;;                       ("D" lsp-ui-peek-find-definitions)
;;                       ("R" lsp-ui-peek-find-references)
;;                       ("i" lsp-ui-peek-find-implementation)
;;                       ("t" lsp-find-type-definition)
;;                       ("s" lsp-signature-help)
;;                       ("o" lsp-describe-thing-at-point)
;;                       ("r" lsp-rename)

;;                       ("f" lsp-format-buffer)
;;                       ("m" lsp-ui-imenu)
;;                       ("x" lsp-execute-code-action)

;;                       ("M-s" lsp-describe-session)
;;                       ("M-r" lsp-restart-workspace)
;;                       ("S" lsp-shutdown-workspace))))


(provide 'ee-lsp)
;;; init-lsp.el ends here
