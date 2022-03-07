;;; init-packages.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Package Boostrap ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(setq package-archives '(("gnu"   . "http://elpa.zilongshanren.com/gnu/")
                         ("melpa" . "http://elpa.zilongshanren.com/melpa/")))
;; (setq package-archives
;;       '(("gnu"   . "http://elpa.gnu.org/packages/")
;;         ("melpa" . "http://melpa.org/packages/")))

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

;; olivetti 文档居中
(use-package olivetti
  :commands olivetti-mode
  :config
  (setq olivetti-body-width 100)
  (setq olivetti-hide-mode-line t))

;; doom-modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; centaur tab
(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t))

(provide 'init-packages)
;;; packages.el ends here
