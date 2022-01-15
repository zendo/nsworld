;;; $DOOMDIR/+keybindings.el -*- lexical-binding: t; -*-

;; Mouse
(blink-cursor-mode -1)               ;禁用指针闪烁
(setq mouse-yank-at-point t)         ;禁用鼠标点击粘贴
(global-unset-key (kbd "<mouse-2>")) ;禁用鼠标中键
(fset 'mouse-save-then-kill 'ignore) ;禁用鼠标右键双击剪切

(setq pixel-scroll-precision-mode t) ;像素滑动 29


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

(map!
 "C-." #'hippie-expand
 "C-\\" #'align-regexp
 "M-s" #'avy-goto-char ;; 默认 isearch 被覆盖
 "C-k" #'crux-smart-kill-line

 "C-s" #'consult-line
 "C-x C-r" #'consult-recent-file
 "C-x C-b" #'consult-buffer
 "C-x 4 r" #'consult-buffer-other-window
 "C-c r" #'consult-ripgrep
 "M-m" #'consult-mark

 "C-}" #'mc/mark-next-like-this
 "C-{" #'mc/mark-previous-like-this
 "C-|" #'mc/mark-all-like-this-dwim

 "C-c <left>" #'winner-undo
 "C-c <right>" #'winner-redo

 "C-c y" #'youdao-dictionary-search-at-point-tooltip
 )
