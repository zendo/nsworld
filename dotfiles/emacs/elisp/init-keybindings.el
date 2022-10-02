;;; init-keybindings.el --- Modify key bindings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Mouse
(blink-cursor-mode -1)               ;禁用指针闪烁
(setq mouse-yank-at-point t)         ;禁用鼠标点击粘贴
(global-unset-key (kbd "<mouse-2>")) ;禁用鼠标中键
(fset 'mouse-save-then-kill 'ignore) ;禁用鼠标右键双击剪切

;; Scroll
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode t))

(ffap-bindings) ;find-file-at-point, smarter C-x C-f when point on path or URL
(global-set-key (kbd "C-z") 'nil) ;unbind C-z
(define-key global-map (kbd "C-c p") project-prefix-map)
(global-set-key [remap kill-buffer] #'kill-this-buffer)
(global-set-key [remap other-window] 'ace-window)

(global-set-key (kbd "<f7>") #'compile)
(global-set-key (kbd "<C-f7>")
                (lambda () (interactive)
                  (save-buffer)
                  (recompile)))

;; easy-kill
(leaf easy-kill
  :ensure t
  :bind (([remap mark-sexp] . easy-mark)
         ([remap kill-ring-save] . easy-kill)))

;; crux
(leaf crux
  :ensure t
  :bind (("C-k" . crux-smart-kill-line)
         ("C-x 4 x" . crux-swap-windows)
         ("C-<return>" . crux-smart-open-line)
         ("C-S-<return>" . crux-smart-open-line-above)))

(leaf *global-set-key
  :leaf-autoload nil
  :bind
  (("M-+" . text-scale-increase)
   ("M-_" . text-scale-decrease)
   ("C-c w x" . ace-swap-window)
   ("C-c w v" . rotate-layout)

   ;; ("C-." . company-complete)
   ("C-." . hippie-expand)

   ("C-c <SPC>" . project-find-file)
   ("C-c C-<SPC>" . project-find-file)
   ("C-c ." . find-file)
   ("C-c /" . consult-ripgrep)
   ("C-c ," . project-switch-to-buffer)
   ("C-x b" . project-switch-to-buffer)

   ("s-d" . dired-jump)
   ("C-;" . comment-line)
   ("C-\\" . align-regexp)
   ("C-x \\" . toggle-input-method)
   ("M-s" . avy-goto-char)
   ("M-z" . avy-zap-up-to-char-dwim)

   ("C-x C-d" . dired-jump)

   ;; file-map
   ("C-c f o" . crux-open-with)
   ("C-c f s" . save-some-buffers)
   ("C-c f S" . crux-sudo-edit)
   ("C-c f x" . crux-delete-file-and-buffer)
   ("C-c f <f2>" . crux-rename-file-and-buffer)
   ;; code-map
   ("C-c c f" . nix-mode-format)
   ("C-c c ." . consult-lsp-diagnostics)
   ;; multiple-cursors-map
   ("C-c m -" . er/mark-inside-quotes)
   ("C-c m =" . er/mark-inside-pairs)
   ;; remove-items
   ("C-c - b" . bookmark-delete)
   ("C-c - r" . recentf-edit-list)
   ("C-c - p" . project-forget-project)
   ))

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
