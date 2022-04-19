;;; Package --- Summary
;;; Commentary:
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; Code:

(load! "+keybindings")

;; basic
(setq user-full-name "zendo"
      user-mail-address "linzway@qq.com"

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
      doom-font (font-spec :family "JetBrains Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "Fira Code")
      doom-big-font-increment 2
      doom-unicode-font (font-spec :family "Noto Color Emoji") ;; "Noto Sans Mono"

      x-gtk-use-native-input t          ;使用外部输入法
      ;; word-wrap-by-category t           ;?
      sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*" ;识别中文标点符号
      recentf-exclude
      '( "^/tmp/" "\\.?ido\\.last$" "\\.revive$" "autosave$" "treemacs-persist" )
      )

(setq org-directory "~/Documents/org/")

(setq deft-directory "~/Documents/org/"
      deft-extensions '("org", "md", "txt", "tex")
      deft-recursive t)

;; UI
;; (add-to-list 'default-frame-alist '(height . 40))
;; (add-to-list 'default-frame-alist '(width . 80))
(add-hook 'window-setup-hook #'toggle-frame-maximized)
(add-to-list 'default-frame-alist '(alpha-background . 98))
;; (after! centaur-tabs
;;   (setq centaur-tabs-style "wave"))

;; Editor
(when (featurep! :editor word-wrap)
  (+global-word-wrap-mode +1))
(global-visual-line-mode 1)
;; (global-prettify-symbols-mode 1) ;Show lambda as λ.

;; alejandra for Nix Code Formatter
(set-formatter! 'alejandra "alejandra --quiet" :modes '(nix-mode))

;;禁用 flycheck
(setq flycheck-disabled-checkers '(sh-shellscript
                                   emacs-lisp
                                   emacs-lisp-checkdoc))
;; (add-to-list 'auto-mode-alist
;; '("bashrc\\'" . conf-mode))

;; hippie expand is dabbrev expand on steroids
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

;; Backup TODO
(add-hook! 'focus-out-hook (save-some-buffers t)) ;失去窗口焦点时保存
;; (setq backup-directory-alist `((".*" . ,my-backup))
;;       undo-tree-auto-save-history t
;;       undo-tree-history-directory-alist
;;       `((".*" . ,my-backup))
;;       ;; create-lockfiles nil   ;stop creating .#lockfile# files 多人编辑中
;;       make-backup-files t    ;备份文件 backup~
;;       backup-by-copying t    ; don't clobber symlinks
;;       kept-new-versions 10   ; keep 10 latest versions
;;       kept-old-versions 0    ; don't bother with old versions
;;       delete-old-versions t  ; don't ask about deleting old versions
;;       version-control t      ; number backups
;;       vc-make-backup-files t ; backup version controlled files
;;       )

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! vundo
  (setq vundo-glyph-alist vundo-unicode-symbols))

;; S: hydra body
(use-package! dired-quick-sort
  :after dired
  :when (not IS-WINDOWS)
  :config
  (dired-quick-sort-setup))


(setq-default custom-file (expand-file-name ".custom.el" doom-emacs-dir))
(when (file-exists-p custom-file)
  (load custom-file))


;;----------------------------------------------------------------------------
;; vertico
;;----------------------------------------------------------------------------
;; 箭头显示当前项
;;;###autoload
(advice-add #'vertico--format-candidate :around
            (lambda (orig cand prefix suffix index _start)
              (setq cand (funcall orig cand prefix suffix index _start))
              (concat
               (if (= vertico--index index)
                   (propertize "» " 'face 'vertico-current)
                 "  ")
               cand)))

;;----------------------------------------------------------------------------
;; align
;;----------------------------------------------------------------------------
;;;###autoload
(defun zendo/align-whitespace (start end)
  "Align columns by whitespace"
  (interactive "r")
  (align-regexp start end
                "\\(\\s-*\\)\\s-" 1 0 t))

(defun zendo/align-& (start end)
  "Align columns by ampersand"
  (interactive "r")
  (align-regexp start end
                "\\(\\s-*\\)&" 1 1 t))

;;----------------------------------------------------------------------------
;; space to newline
;;----------------------------------------------------------------------------
;;;###autoload
(defun zendo/space-to-newline ()
  "Replace space sequence to a newline char.
Works on current block or selection.

URL `http://ergoemacs.org/emacs/emacs_space_to_newline.html'
Version 2017-08-19"
  (interactive)
  (let* ( $p1 $p2 )
    (if (use-region-p)
        (progn
          (setq $p1 (region-beginning))
          (setq $p2 (region-end)))
      (save-excursion
        (if (re-search-backward "\n[ \t]*\n" nil "move")
            (progn (re-search-forward "\n[ \t]*\n")
                   (setq $p1 (point)))
          (setq $p1 (point)))
        (re-search-forward "\n[ \t]*\n" nil "move")
        (skip-chars-backward " \t\n" )
        (setq $p2 (point))))
    (save-excursion
      (save-restriction
        (narrow-to-region $p1 $p2)
        (goto-char (point-min))
        (while (re-search-forward " +" nil t)
          (replace-match "\n" ))))))
