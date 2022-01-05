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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme
(use-package doom-themes)
(use-package atom-one-dark-theme)
(use-package leuven-theme)
;; (use-package monokai-theme)
;; (use-package vscode-dark-plus-theme)
;; (use-package zenburn)
;; (use-package eclipse-theme)
;; (load-theme 'atom-one-dark t)
(load-theme 'doom-tomorrow-night t)

(use-package all-the-icons)

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

;; Smartly select region, rectangle, multi cursors
(use-package smart-region
  :hook (after-init . smart-region-on))

;; anzu
(use-package anzu)
(global-set-key [remap query-replace] 'anzu-query-replace)
(global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)

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

;; doom-modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; powerline modeline
;; (use-package powerline
;;   :config
;;   (powerline-default-theme))

;; all-the-icons-ivy-rich
(use-package all-the-icons-ivy-rich
  :init (all-the-icons-ivy-rich-mode 1))

;; dired-sidebar
(use-package dired-sidebar
  :defer t
  :bind (([f1] . dired-sidebar-toggle-sidebar))
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-theme 'icons))

;; ibuffer-sidebar
(use-package ibuffer-sidebar
  :defer t)

;; vterm
(use-package vterm
  :defer t
  :config
  (setq vterm-shell "zsh")
  (define-key vterm-mode-map (kbd "<f9>")  'shell-pop))

;; shell-pop
(use-package shell-pop
  :defer t
  :bind ([f9] . shell-pop)
  :init
  (setq shell-pop-window-size 30
        shell-pop-shell-type
        (cond ((fboundp 'vterm) '("vterm" "*vterm*" #'vterm))
              ((eq system-type 'windows-nt) '("eshell" "*eshell*" #'eshell))
              (t '("terminal" "*terminal*"
                   (lambda () (term shell-pop-term-shell)))))))


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
(use-package dashboard
  :diminish (dashboard-mode page-break-lines-mode)
  :custom
  (dashboard-startup-banner 2)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-set-footer nil)
  (dashboard-center-content t)

  (dashboard-items '((recents  . 12)
                     (bookmarks . 5)
                     (projects . 5)))
  :config
  (dashboard-setup-startup-hook))


;; Magit
(use-package magit
  :defer t
  :if (executable-find "git")
  :config
  (setq magit-completing-read-function 'ivy-completing-read)
  :bind (
         ("C-x C-g" . magit-dispatch)
         ("C-x g" . magit-status)
         ("C-c g s" . magit-status)
         ("C-c g x" . magit-checkout)
         ("C-c g c" . magit-commit)
         ("C-c g p" . magit-push)
         ("C-c g u" . magit-pull)
         ("C-c g e" . magit-ediff-resolve)
         ("C-c g r" . magit-rebase-interactive)
         ("C-c g f" . magit-format-patch)))


(provide 'packages)
;;; packages.el ends here
