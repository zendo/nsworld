;;; packages.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Package Boostrap ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(setq package-archives '(("gnu"   . "http://elpa.zilongshanren.com/gnu/")
                         ("melpa" . "http://elpa.zilongshanren.com/melpa/")))

;; Initialize packages
(unless (bound-and-true-p package--initialized) ; To avoid warnings in 27
  (setq package-enable-at-startup nil)          ; To prevent initializing twice
  (package-initialize))

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; use-package setting
(setq use-package-always-ensure t
      ;; use-package-always-defer t
      ;; use-package-verbose t
      use-package-enable-imenu-support t)
(require 'use-package)

(require 'cl-lib)
;; (use-package dash)
(use-package s) ;string manipulation
(use-package f) ;file manipulation

(use-package bind-key)
(use-package diminish)
(diminish 'visual-line-mode)
(diminish 'eldoc-mode) ;echo area 显示函数的参数列表

;; Control use of local variables in files you visit.
;; :safe means set the safe variables, and ignore the rest.
(setq enable-local-variables :safe)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Extensions ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;
;; Theme
(use-package monokai-theme)
(use-package atom-one-dark-theme)
(use-package vscode-dark-plus-theme)
;; (use-package zenburn)
(use-package leuven-theme)
;; (use-package eclipse-theme)
(load-theme 'atom-one-dark t)

;; counsel
(use-package counsel
  :diminish ivy-mode counsel-mode)

;; ivy
(use-package ivy
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t) ;Add recent files and bookmarks to the ivy-switch-buffer
    (setq ivy-initial-inputs-alist nil) ;Don't use ^ as initial input
    (setq counsel-yank-pop-separator "\n-------\n")
    (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)))

;; orderless
;; (use-package orderless
;;   :ensure t
;;   :custom (completion-styles '(orderless)))
;; (setq ivy-re-builders-alist '((t . orderless-ivy-re-builder)))

;; amx
(use-package amx
  :config
  (setq amx-save-file (expand-file-name "amx" my-temp)))

;; ivy-rich
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; Which-Key
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode))

;; Helpful
(use-package helpful
  :defer t
  :defines ivy-initial-inputs-alist)

;; undo-fu
;; (use-package undo-fu)

;; undo-tree C-x u
(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    ;; (setq undo-tree-visualizer-diff t)
    (setq undo-tree-history-directory-alist
          `((".*" . ,my-temp)))
    (setq undo-tree-auto-save-history t)))

;; expand-region
(use-package expand-region)

;; iedit
(use-package iedit
  :defer t)

;; multiple-cursors
(use-package multiple-cursors
  :defer t)

;; anzu
(use-package anzu)

;; wgrep
(use-package wgrep
  :defer t)

;; hl-todo
(use-package hl-todo
  :config (global-hl-todo-mode))

;; macrostep
(use-package macrostep)

;; rainbow 颜色代码显色 #00FF00
(use-package rainbow-mode
  :commands rainbow-mode)

;; rainbow-delimiters  彩虹括号
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Narrow/Widen
(use-package fancy-narrow
  :diminish
  :hook (after-init . fancy-narrow-mode))

;; avy
(use-package avy)

;; avy-zap
(use-package avy-zap)

;; ace-window
(use-package ace-window)
(global-set-key [remap other-window] 'ace-window)

;; burly save buffers windows
(use-package burly)


;; Youdao Dictionay
(use-package youdao-dictionary
  :defer t
  :config
  ;; Cache documents
  (setq url-automatic-caching t)
  ;; Enable Chinese word segmentation support (支持中文分词)
  (setq youdao-dictionary-use-chinese-word-segmentation t))

;; RIME 中文输入法
;; (use-package rime
;;   :custom
;;   (default-input-method "rime"))

;; olivetti 文档居中
(use-package olivetti
  :commands olivetti-mode
  :config
  (setq olivetti-body-width 100)
  (setq olivetti-hide-mode-line t))

;; bash-completion
(when (eq system-type 'gnu/linux)
  (use-package bash-completion
    :defer t
    :init
    (autoload 'bash-completion-dynamic-complete
      "bash-completion"
      "BASH completion hook")
    (add-hook 'shell-dynamic-complete-functions
              'bash-completion-dynamic-complete)))

;; exec-path-from-shell
(when (eq system-type 'gnu/linux)
  (use-package exec-path-from-shell
    :custom
    (exec-path-from-shell-check-startup-files nil)
    (exec-path-from-shell-variables '("PATH" "MANPATH" "PYTHONPATH" "GOPATH"))
    (exec-path-from-shell-arguments '("-l"))
    :init
    (exec-path-from-shell-initialize)))

;; auto-sudoedit
;; (when (eq system-type 'gnu/linux)
;;   (use-package auto-sudoedit
;;     :config (auto-sudoedit-mode)))

;; powerline
(use-package powerline
  :config
  (powerline-default-theme))

;; vterm
;; (when (eq system-type 'gnu/linux)
;;   (use-package vterm)
;;   (with-eval-after-load 'vterm
;;     (define-key vterm-mode-map (kbd "<f4>") 'shell-pop)))

;; shell-pop
(use-package shell-pop
  :bind ([f4] . shell-pop)
  :init (let ((val
               (if (eq system-type 'windows-nt)
                   '("eshell" "*eshell*" (lambda () (eshell)))
                 '("ansi-term" "*ansi-term*"
                   (lambda () (ansi-term shell-pop-term-shell))))))
          (setq shell-pop-shell-type val)))

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :commands projectile-mode
  :bind-keymap ("C-c p" . projectile-command-map)
  :init (setq projectile-require-project-root nil) ; make projectile usable for every directory
  :config
  (progn
    (projectile-mode 1)
    (setq projectile-completion-system 'ivy)
    (setq projectile-switch-project-action #'projectile-dired)))

;; dashboard
;; (use-package dashboard
;;   :diminish (dashboard-mode page-break-lines-mode)
;;   :custom
;;   (dashboard-center-content t)
;;   (dashboard-set-footer nil)
;;   (dashboard-startup-banner 2)
;;   (dashboard-items '((recents  . 8)
;;                      (bookmarks . 5)
;;                      (projects . 5)))
;;   :config
;;   (dashboard-setup-startup-hook))


;; Magit
(use-package magit
  :if (executable-find "git")
  :config
  (setq magit-completing-read-function 'ivy-completing-read)
  :bind (("C-x g s" . magit-status)
         ("C-x g x" . magit-checkout)
         ;; ("C-x g c" . magit-commit)
         ;; ("C-x g p" . magit-push)
         ;; ("C-x g u" . magit-pull)
         ("C-x g e" . magit-ediff-resolve)
         ("C-x g r" . magit-rebase-interactive)
         ("C-x g f" . magit-format-patch)))

;; (use-package magit-popup
;;   :defer t)


(provide 'packages)
;;; packages.el ends here
