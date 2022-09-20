;;; init-packages.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'package)
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

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
  :defer t)

;; Garbage Collector Magic Hack
(use-package gcmh
  :diminish
  :hook (emacs-startup . gcmh-mode)
  :init
  (setq gcmh-idle-delay 'auto
        gcmh-auto-idle-delay-factor 10
        gcmh-high-cons-threshold #x1000000)) ; 16MB

;; expand-region
(use-package expand-region)

;; mwim ;moving to the beginning/end code
(use-package mwim)

;; move-text M-up/M-down
(use-package move-text
  :init (move-text-default-bindings))

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

;; rotate
(use-package rotate)

;; burly save buffers windows
(use-package burly)

;; fanyi
(use-package fanyi)

;; olivetti 文档居中
(use-package olivetti
  :commands olivetti-mode
  :config
  (setq olivetti-body-width 100)
  (setq olivetti-hide-mode-line t))

;; doom-modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-buffer-file-name-style 'relative-to-project))


(provide 'init-packages)
;;; init-packages.el ends here
