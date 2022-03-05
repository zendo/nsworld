;;; Package --- Summary
;;; Commentary:
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; Code:

(load! "+keybindings")

(setq user-full-name "zendo"
      user-mail-address "linzway@qq.com"

      confirm-kill-emacs nil
      confirm-kill-processes nil
      delete-by-moving-to-trash t
      save-interprogram-paste-before-kill t ;save clipboard

      display-line-numbers-type 't ;t/nil/relative
      calendar-week-start-day 1 ;Monday as first day of week

      doom-theme 'doom-tomorrow-night
      ;; doom-theme 'doom-vibrant
      doom-font (font-spec :family "JetBrains Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "Fira Code")
      doom-big-font-increment 2
      doom-unicode-font (font-spec :family "Noto Sans Mono")

      x-gtk-use-native-input t          ;使用外部输入法
      sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*" ;识别中文标点符号
      recentf-exclude
      '( "^/tmp/" "\\.?ido\\.last$" "\\.revive$" "autosave$" "treemacs-persist")
      )

(add-hook! 'focus-out-hook (save-some-buffers t)) ;失去焦点时保存
;; (add-hook 'window-setup-hook #'toggle-frame-maximized)
(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(width . 80))
(add-to-list 'default-frame-alist '(alpha-background . 98))

(+global-word-wrap-mode +1)
;; (global-prettify-symbols-mode 1) ;Show lambda as λ.

;; (add-to-list 'auto-mode-alist
             ;; '("bashrc\\'" . conf-mode))



;; Bacup sth TODO
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

;; Doom exposes five (optional) variables for controlling fonts in D
;; oom. Here
;; 1are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

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


(setq org-directory "~/Documents/Notes/")

(setq deft-directory "~/Documents/Notes/"
      deft-extensions '("org", "md", "txt", "tex")
      deft-recursive t)


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
