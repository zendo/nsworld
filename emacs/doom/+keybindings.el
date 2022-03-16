;;; Package --- Summary
;;; Commentary:
;;; $DOOMDIR/+keybindings.el -*- lexical-binding: t; -*-
;;; Code:

;; Mouse
(blink-cursor-mode -1)               ;禁用指针闪烁
(setq mouse-yank-at-point t)         ;禁用鼠标点击粘贴
(global-unset-key (kbd "<mouse-2>")) ;禁用鼠标中键
(fset 'mouse-save-then-kill 'ignore) ;禁用鼠标右键双击剪切

;; Scroll
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode t))

;; Doom special
(setq +default-want-RET-continue-comments nil)

;; Common
(global-set-key (kbd "C-z") nil)

(global-set-key (kbd "<f1>") '+treemacs/toggle)
(define-key! treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action)

(global-set-key (kbd "<f2>") '+doom-dashboard/open)
(global-set-key (kbd "<f9>") '+vterm/toggle)
(after! vterm
  (setq vterm-shell "zsh")
  (define-key vterm-mode-map (kbd "<f9>")  '+vterm/toggle))

(global-set-key [remap kill-buffer] #'kill-this-buffer)

(global-set-key [remap mark-sexp] 'easy-mark)
(global-set-key [remap kill-ring-save] 'easy-kill)

(global-set-key [remap query-replace] 'anzu-query-replace)
(global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)

(map!
 "C-." #'hippie-expand
 "C-\\" #'align-regexp
 "M-s" #'avy-goto-char ;默认 isearch 被覆盖

 "C-s" #'consult-line
 "C-x C-r" #'consult-recent-file
 "C-x C-b" #'consult-buffer
 "C-x 4 r" #'consult-buffer-other-window
 "C-c r" #'consult-ripgrep
 "M-y" #'consult-yank-pop
 "M-m" #'consult-mark

 "C-}" #'mc/mark-next-like-this
 "C-{" #'mc/mark-previous-like-this
 "C-|" #'mc/mark-all-like-this-dwim

 "C-c <left>" #'winner-undo
 "C-c <right>" #'winner-redo

 "C-x C-g" #'magit-status

 "C-c y" #'youdao-dictionary-search-at-point-tooltip
 )

(map!
 :n "C-=" #'er/expand-region
 :i "C-=" #'er/expand-region
 :n "C-y" #'yank
 :i "C-y" #'yank
 :n "C-e" #'end-of-line
 :n "C-k" #'crux-smart-kill-line
 :leader
 "=" #'er/expand-region
 "y" #'youdao-dictionary-search-at-point-tooltip
 :prefix ("-" . "remove-lists")
 "b" #'bookmark-delete
 "r" #'recentf-edit-list
 "p" #'projectile-remove-known-project
 :prefix ("w" . "window")
 "0" #'delete-window
 "1" #'delete-other-windows
 :prefix ("z" . "zap")
 "SPC" #'just-one-space
 )

;; Dired
(put 'dired-find-alternate-file 'disabled nil) ;a键进入目录时只用一个buffer
(map! :map dired-mode-map
    :after dired
    "f" #'ido-find-file
    "F" #'find-name-dired
    "<RET>" #'dired-find-alternate-file
    "." #'dired-hide-details-mode
    "/" #'funs/dired-filter-show-match
    "b" #'(lambda ()
    (interactive)
    (find-alternate-file ".."))
    )
;;;###autoload
(defun funs/dired-filter-show-match ()
  "Only show filter file."
  (interactive)
  (call-interactively #'dired-mark-files-regexp)
  (command-execute "tk"))


;; view-mode key
;; (defvar view-mode-map) ;定义变量消除 flaycheck error
;; (with-eval-after-load 'view
;;   (bind-key "g" 'goto-line view-mode-map)
;;   (bind-key "h" 'backward-char view-mode-map)
;;   (bind-key "j" 'next-line view-mode-map)
;;   (bind-key "k" 'previous-line view-mode-map)
;;   (bind-key "l" 'forward-char view-mode-map)
  ;; (bind-key "b" 'View-scroll-page-backward view-mode-map))



;; 新建 window 并直接切换至新窗口
;; (global-set-key (kbd "C-x 2")
;;                 (lambda()
;;                   (interactive)
;;                   (split-window-below)
;;                   (select-window (next-window))))
;; (global-set-key (kbd "C-x 3")
;;                 (lambda()
;;                   (interactive)
;;                   (split-window-right)
;;                   (select-window (next-window))))
