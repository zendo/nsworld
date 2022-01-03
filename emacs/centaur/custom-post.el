;;; custom-post.el --- user custom-post file    -*- lexical-binding: t no-byte-compile: t -*-
;;; Commentary:
;;; Code:

;; Centaur specifieqd
(when sys/linuxp
  (setq centaur-org-directory "~/.dotworld/org/"))


(setq system-time-locale "C"
      confirm-kill-processes 'nil)

;; Mouse
(blink-cursor-mode -1)               ;禁用指针闪烁
(setq mouse-yank-at-point t)         ;禁用鼠标点击粘贴
(global-unset-key (kbd "<mouse-2>")) ;禁用鼠标中键
(fset 'mouse-save-then-kill 'ignore) ;禁用鼠标右键双击剪切

;; Keybindings
(global-set-key (kbd "C-z") 'nil) ;unbind C-zzzzz
(global-set-key [remap kill-buffer] #'kill-this-buffer)

(use-package crux)
(global-set-key [remap kill-line]  #'crux-smart-kill-line)
(global-set-key [remap rect-hydra/body]  #'crux-smart-open-line)
(global-set-key [(control shift return)] #'crux-smart-open-line-above)

(bind-keys*
 ([f1] . treemacs)
 ;; ("C-." . company-complete) ;; imenu-counsel
 ("C-." . hippie-expand)
 ("C-\\" . align-regexp)
 ("C-x \\" . toggle-input-method)
 ("M-m" . pop-to-mark-command)
 ("M-s" . avy-goto-char) ;; 覆盖默认按键 isearch
 ("C-c C-o" . ivy-occur)

 ("M-+" . text-scale-increase)
 ("M-_" . text-scale-decrease)

 ("C-}" . mc/mark-next-like-this)
 ("C-{" . mc/mark-previous-like-this)
 ("C-|" . mc/mark-all-like-this-dwim))

;; 失去焦点时保存
(defun save-all ()
  (interactive)
  (save-some-buffers t))
(add-hook 'focus-out-hook 'save-all)


;; 备份
(defconst my-backup (expand-file-name "my-backup" user-emacs-directory))
(unless (file-exists-p my-backup)
  (make-directory my-backup))

(setq backup-directory-alist `((".*" . ,my-backup))
      undo-tree-auto-save-history t
      undo-tree-history-directory-alist
      `((".*" . ,my-backup))
      ;; create-lockfiles nil   ;stop creating .#lockfile# files 多人编辑中
      make-backup-files t    ;备份文件 backup~
      backup-by-copying t    ; don't clobber symlinks
      kept-new-versions 10   ; keep 10 latest versions
      kept-old-versions 0    ; don't bother with old versions
      delete-old-versions t  ; don't ask about deleting old versions
      version-control t      ; number backups
      vc-make-backup-files t ; backup version controlled files
      )

;; nixos
(use-package nix-mode
  :mode "\\.nix\\'")

;; light theme
(use-package cloud-theme)


;; vterm
(with-eval-after-load 'vterm
  (setq vterm-shell "zsh")
  (define-key vterm-mode-map (kbd "<f9>")  'shell-pop))


;; dired key
(put 'dired-find-alternate-file 'disabled nil) ;a键进入目录时只用一个buffer
(define-key dired-mode-map "f" 'counsel-find-file)
(define-key dired-mode-map "F" 'find-name-dired)
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
(define-key dired-mode-map "." 'dired-hide-details-mode)
(define-key dired-mode-map "/" 'funs/dired-filter-show-match)
(define-key dired-mode-map "b"
  (lambda ()
    (interactive)
    (find-alternate-file "..")))
;;;###autoload
(defun funs/dired-filter-show-match ()
  "Only show filter file."
  (interactive)
  (call-interactively #'dired-mark-files-regexp)
  (command-execute "tk"))

;; view-mode key
(defvar view-mode-map) ;定义变量消除 flaycheck error
(with-eval-after-load 'view
  (bind-key "g" 'goto-line view-mode-map)
  (bind-key "h" 'backward-char view-mode-map)
  (bind-key "j" 'next-line view-mode-map)
  (bind-key "k" 'previous-line view-mode-map)
  (bind-key "l" 'forward-char view-mode-map)
  (bind-key "b" 'View-scroll-page-backward view-mode-map))


;;----------------------------------------------------------------------------
;; stop using mouse minibuffer
;;----------------------------------------------------------------------------
;;;###autoload
(defun stop-using-minibuffer ()
  "Kill the minibuffer."
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))
;; (add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

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
