;;; Package --- Summary
;;; Commentary:
;;; $DOOMDIR/keybindings.el -*- lexical-binding: t; -*-
;;; Code:

;; Mouse
(blink-cursor-mode -1)               ;禁用指针闪烁
(setq mouse-yank-at-point t)         ;禁用鼠标点击粘贴
(global-unset-key (kbd "<mouse-2>")) ;禁用鼠标中键
(fset 'mouse-save-then-kill 'ignore) ;禁用鼠标右键双击剪切

;; Scroll
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode t))

;; Doom 别在新行加注释
(setq +default-want-RET-continue-comments nil)

;; (global-set-key (kbd "C-z") nil)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-S-z") 'undo-redo)

(when IS-WINDOWS
  (global-set-key (kbd "<f2>") '+eshell/toggle))

(when IS-LINUX
  (global-set-key (kbd "<f2>") '+vterm/toggle)
  (after! vterm
    (setq vterm-shell "zsh")
    (define-key vterm-mode-map (kbd "<f2>")  '+vterm/toggle)))

(after! treemacs
  (define-key! treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))

(global-set-key [remap kill-buffer] #'kill-this-buffer)
(global-set-key [remap query-replace] 'anzu-query-replace)
(global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)

;; set-mark multiple times to expands
(use-package! smart-region
  :hook (after-init . smart-region-on))

(map!
 "C-\\" #'align-regexp
 "M-s" #'avy-goto-word-1 ;默认 isearch 被覆盖
 "<f1>" #'+treemacs/toggle

 "C-s" #'consult-line
 "C-x C-r" #'consult-recent-file
 "C-x C-b" #'consult-buffer
 "M-y" #'consult-yank-pop
 "M-m" #'consult-mark
 "C-x 4 r" #'consult-buffer-other-window
 "C-x 4 x" #'ace-swap-window
 [remap other-window] #'ace-window

 "C-." #'hippie-expand
 "C-," #'+company/complete
 "C-;" #'comment-line

 "C-k" #'crux-smart-kill-line
 "C-x u" #'vundo
 "C-x j" #'dired-jump-other-window

 "C-}" #'mc/mark-next-like-this
 "C-{" #'mc/mark-previous-like-this
 "C-|" #'mc/mark-all-like-this-dwim
 "s-<mouse-1>" #'mc/add-cursor-on-click

 [remap kill-ring-save] #'easy-kill
 [remap mark-sexp] #'easy-mark-sexp
 [remap mark-word] #'easy-mark-word
 "M-z" #'avy-zap-to-char

 "s-w" #'+hydra/window-nav/body
 "s-=" #'+hydra/text-zoom/body

 "s-g" #'magit-status
 "C-x g" #'magit-status
 :map magit-status-mode-map
 "p" 'magit-push
 )

;; emacs keymap
(unless (modulep! :editor evil +everywhere)
  (setq doom-leader-alt-key "C-c")
  (map!
   :leader
   "y" #'fanyi-dwim2
   "g" #'magit-status
   "x" #'+hydra/window-nav/body
   "<left>" #'winner-undo
   "<right>" #'winner-redo
   "<SPC>" #'project-find-file
   "C-<SPC>" #'project-find-file
   "C-j" #'dired-jump
   "," #'consult-buffer
   "." #'find-file
   "/" #'consult-ripgrep
   ":" #'execute-extended-command
   :prefix ("-" . "remove-lists")
   "b" #'bookmark-delete
   "r" #'recentf-edit-list
   "p" #'project-forget-project
   :prefix ("b" . "buffer")
   "b" #'consult-buffer
   "k" #'kill-current-buffer
   "K" #'crux-kill-other-buffers
   "s" #'save-some-buffers
   "l" #'+ibuffer/open-for-current-workspace
   :prefix ("f" . "file")
   "<f2>" #'crux-rename-file-and-buffer
   "s" #'save-some-buffers
   :prefix ("z" . "zap")
   "SPC" #'just-one-space
   "z" #'avy-zap-to-char
   :prefix ("m" . "multiple-cursors")
   "-" #'er/mark-inside-quotes
   "=" #'er/mark-inside-pairs
   :prefix ("w" . "window")
   "x" #'ace-swap-window
   "v" #'rotate-layout
   ))

;; evil keymap
(when (modulep! :editor evil +everywhere)
  (map!
   :niv "C-=" #'er/expand-region
   :niv "C-y" #'yank
   :niv "C-k" #'crux-smart-kill-line
   :niv "C-e" #'end-of-line
   :leader
   "y" #'fanyi-dwim2
   "<left>" #'next-buffer
   "<right>" #'previous-buffer
   :prefix ("-" . "remove-lists")
   "b" #'bookmark-delete
   "r" #'recentf-edit-list
   "p" #'projectile-remove-known-project
   :prefix ("f" . "file")
   "<f2>" #'crux-rename-file-and-buffer
   :prefix ("w" . "window")
   "0" #'delete-window
   "1" #'delete-other-windows
   "2" #'split-window-vertically
   "3" #'split-window-horizontally
   "," #'winner-undo
   "." #'winner-redo
   "x" #'ace-swap-window
   "v" #'rotate-layout
   :prefix ("z" . "zap")
   "SPC" #'just-one-space
   ))

;; meow
;; (when (featurep! :editor meow)
;;   (map!
;;    ))

;; view-mode key
(defvar view-mode-map) ;定义变量消除 flaycheck error
(with-eval-after-load 'view
  (bind-key "g" 'goto-line view-mode-map)
  (bind-key "h" 'backward-char view-mode-map)
  (bind-key "j" 'next-line view-mode-map)
  (bind-key "k" 'previous-line view-mode-map)
  (bind-key "l" 'forward-char view-mode-map)
  (bind-key "b" 'View-scroll-page-backward view-mode-map))

;; 新建 window 并切换过去
(global-set-key (kbd "C-x 2")
                (lambda()
                  (interactive)
                  (split-window-below)
                  (select-window (next-window))))
(global-set-key (kbd "C-x 3")
                (lambda()
                  (interactive)
                  (split-window-right)
                  (select-window (next-window))))
