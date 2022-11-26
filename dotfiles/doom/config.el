;;; Package --- Summary
;;; Commentary:
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; Code:

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys

;; https://github.com/VitalyAnkh/config/blob/master/doom/config.org

(load! "keybindings")
(load! "functions")

;; environment
(when IS-WINDOWS
  (setq doom-font (font-spec :family "JetBrains Mono" :size 26)
      doom-unicode-font (font-spec :family "Segoe UI Emoji")

      default-directory "~/Desktop/"
      org-directory "~/Documents/Notes/"
      ))

(when IS-LINUX
  (setq doom-font (font-spec :family "JetBrains Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "Fira Code")
      doom-big-font-increment 2
      doom-unicode-font (font-spec :family "Noto Color Emoji")

      ;; org-directory "~/Documents/Notes/"
      ))

;; basic
(setq user-full-name "zendo"
      user-mail-address "linzway@qq.com"

      ;; inhibit-default-init nil
      confirm-kill-emacs nil
      confirm-kill-processes nil
      delete-by-moving-to-trash t
      save-interprogram-paste-before-kill t ;save clipboard
      ;; mouse-drag-and-drop-region-cross-program t
      ;; mouse-drag-and-drop-region t

      display-line-numbers-type 't ;t nil relative
      calendar-week-start-day 1 ;Monday as first day of week

      doom-theme 'doom-tomorrow-night
      ;; doom-theme 'doom-vibrant
      +default-want-RET-continue-comments nil ; 别在新行加注释
      warning-minimum-level :emergency ; temp disable

      undo-in-region t
      ;; mouse-autoselect-window t
      set-mark-command-repeat-pop t  ; Repeating C-SPC after popping mark pops
      ;; word-wrap-by-category t        ;?
      sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*" ;识别中文标点符号
      recentf-exclude
      '( "^/tmp/" "\\.?ido\\.last$" "\\.revive$" "autosave$" "treemacs-persist" )
      )

;;content overview show2levels
(after! org
  (setq org-startup-folded t))

;; UI
;; (add-to-list 'default-frame-alist '(height . 40))
;; (add-to-list 'default-frame-alist '(width . 80))
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(alpha-background . 98))

;; Editor
(when (modulep! :editor word-wrap)
  (+global-word-wrap-mode +1))
(global-visual-line-mode 1)

;; Nix Mode
(add-hook 'nix-mode-hook #'rainbow-delimiters-mode)
;; (add-hook! nix-mode #'lsp!)
;; alejandra for Nix Code Formatter :C-c c f
(set-formatter! 'alejandra "alejandra --quiet" :modes '(nix-mode))

;; disable flycheck in some mode
(setq flycheck-disabled-checkers '(sh-shellscript
                                   emacs-lisp
                                   emacs-lisp-checkdoc))
;; (add-to-list 'auto-mode-alist
;; '("bashrc\\'" . conf-mode))

;; 窗口失去焦点时保存
(add-function :after after-focus-change-function (lambda () (save-some-buffers t)))

;; recentf 不要保存 dired 记录
(define-advice doom--recentf-add-dired-directory-h (:override ()))

;; hippie expand is dabbrev expand on steroids
;; doom 顺序似乎不对，这里覆盖自己的配置
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev                 ;搜索当前 buffer, expand word "dynamically"
        try-expand-dabbrev-all-buffers     ;搜索所有 buffer
        try-expand-dabbrev-from-kill       ;从 kill-ring 中搜索
        try-complete-file-name-partially   ;文件名部分匹配
        try-complete-file-name             ;文件名匹配
        try-expand-all-abbrevs             ;匹配所有缩写词, according to all abbrev tables
        try-expand-list                    ;补全一个列表
        try-expand-line                    ;补全当前行
        try-complete-lisp-symbol-partially ;部分补全 lisp symbol
        try-complete-lisp-symbol))         ;补全 lisp symbol

;; visual undo history
(after! vundo
  (setq vundo-glyph-alist vundo-unicode-symbols)
  (setq vundo-roll-back-on-quit nil))

;; Dired
(put 'dired-find-alternate-file 'disabled nil) ;a键进入目录时只用一个buffer
(map! :map dired-mode-map
      :after dired
      "f" #'ido-find-file
      "<RET>" #'dired-find-alternate-file
      "<SPC>" #'dired-find-alternate-file
      "." #'dired-hide-details-mode
      "/" #'funs/dired-filter-show-match
      "b" #'(lambda ()
              (interactive)
              (find-alternate-file ".."))
      )
;;;###autoload
(defun funs/dired-filter-show-match ()
  "Only show filter file"
  (interactive)
  (call-interactively #'dired-mark-files-regexp)
  (command-execute "tk"))

;; throw custom file
(setq-default custom-file (expand-file-name ".custom.el" doom-local-dir))
(when (file-exists-p custom-file)
  (load custom-file))
