;;; init-keybindings.el --- Modify key bindings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Scroll
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode t))

(blink-cursor-mode -1)               ;禁用指针闪烁
(setq mouse-yank-at-point t)         ;禁用鼠标点击粘贴
(global-unset-key (kbd "<mouse-2>")) ;禁用鼠标中键
(fset 'mouse-save-then-kill 'ignore) ;禁用鼠标右键双击剪切

(ffap-bindings) ;find-file-at-point, smarter C-x C-f when point on path or URL
(global-set-key (kbd "C-z") 'nil) ;unbind C-zzzzz
(global-set-key [remap kill-buffer] #'kill-this-buffer)

(global-set-key (kbd "<f7>") #'compile)
(global-set-key (kbd "<C-f7>")
                (lambda () (interactive)
                  (save-buffer)
                  (recompile)))

;; move-text M-up/M-down
(use-package move-text
  :init (move-text-default-bindings))

;; easy-kill
(use-package easy-kill
             :config
             (global-set-key [remap mark-sexp] 'easy-mark)
             (global-set-key [remap kill-ring-save] 'easy-kill))

;; mwim
(use-package mwim
  :bind
  ("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line))

;; crux
(use-package crux
  :bind (;("C-a" . crux-move-beginning-of-line)
         ("C-k" . crux-smart-kill-line)
         ("C-x 4 x" . crux-swap-windows)))
(global-set-key [(control return)] #'crux-smart-open-line)
(global-set-key [(control shift return)] #'crux-smart-open-line-above)

;; prefix map
(bind-keys :prefix-map file-map
           :prefix "C-c f"
           ("0" . revert-buffer)
           ("o" . crux-open-with)
           ("s" . crux-sudo-edit)
           ("x" . crux-delete-file-and-buffer)
           ("<f2>" . crux-rename-file-and-buffer)

           :prefix-map window-map
           :prefix "C-c w"
           ("w" . burly-bookmark-windows)
           ("f" . burly-bookmark-frames)
           ("o" . burly-open-bookmark)
           ("x" . crux-swap-windows)

           :prefix-map project
           :prefix "C-c p"
           ("p" . project-switch-project)

           :prefix-map remove-lists
           :prefix "C-c -"
           ("b" . bookmark-delete)
           ("r" . recentf-edit-list)
           ("p" . projectile-remove-known-project)
           )


(bind-keys*
 ("C-h f" . helpful-callable)
 ("C-h v" . helpful-variable)
 ("C-h k" . helpful-key)

 ("M-+" . text-scale-increase)
 ("M-_" . text-scale-decrease)

 ("C-=" . er/expand-region)
 ;; ("C-." . company-complete)
 ("C-." . hippie-expand)

 ("C-c <SPC>" . project-switch-project)
 ("C-c ." . project-find-file)
 ("C-c ," . project-switch-to-buffer)

 ("C-;" . iedit-mode)
 ("C-\\" . align-regexp)
 ("C-x \\" . toggle-input-method)
 ("M-s" . avy-goto-char)
 ("M-z" . avy-zap-up-to-char-dwim)
 ("C-}" . mc/mark-next-like-this)
 ("C-{" . mc/mark-previous-like-this)
 ("C-|" . mc/mark-all-like-this-dwim)

 ("C-x C-d" . dired-jump)
 ("C-x u" . vundo)
 ("C-c Y" . youdao-dictionary-search-at-point)
 ("C-c y" . youdao-dictionary-search-at-point-tooltip))


;; view-mode key
(defvar view-mode-map) ;定义变量消除 flaycheck error
(with-eval-after-load 'view
  (bind-key "g" 'goto-line view-mode-map)
  (bind-key "h" 'backward-char view-mode-map)
  (bind-key "j" 'next-line view-mode-map)
  (bind-key "k" 'previous-line view-mode-map)
  (bind-key "l" 'forward-char view-mode-map)
  (bind-key "b" 'View-scroll-page-backward view-mode-map))


;; 新建 window 并直接切换至新窗口
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


(provide 'init-keybindings)
;;; keybindings.el ends here
