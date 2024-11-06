;;; ee-keybindings.el --- Modify key bindings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Mouse
(blink-cursor-mode -1)               ;禁用指针闪烁
(setq mouse-yank-at-point t)         ;禁用鼠标点击粘贴
(global-unset-key (kbd "<mouse-2>")) ;禁用鼠标中键
(fset 'mouse-save-then-kill 'ignore) ;禁用鼠标右键双击剪切

;; Scroll
(pixel-scroll-precision-mode t)

(ffap-bindings) ;find-file-at-point, smarter C-x C-f when point on path or URL
(global-set-key (kbd "C-z") 'nil) ;unbind C-z
(global-set-key [remap kill-buffer] #'kill-this-buffer)

;; (use-package devil
;;   :config
;;   (global-devil-mode)
;;   (global-set-key (kbd "C-,") 'global-devil-mode))

(bind-keys*
 ("M-+" . text-scale-increase)
 ("M-_" . text-scale-decrease)

 ;; ("C-." . company-complete)
 ("C-." . hippie-expand)
 ("C-;" . comment-line)
 ("C-\\" . align-regexp)
 ("C-x \\" . toggle-input-method)

 ;; doom-like
 ("C-c <SPC>" . project-find-file)
 ("C-c C-<SPC>" . project-find-file)
 ("C-c ." . find-file)
 ("C-c /" . consult-ripgrep)
 ("C-c ," . project-switch-to-buffer)
 ("C-x b" . project-switch-to-buffer)

 ("C-x 2" . (lambda()
              (interactive)
              (split-window-below)
              (select-window (next-window))))
 ("C-x 3" . (lambda()
              (interactive)
              (split-window-right)
              (select-window (next-window))))

 ("<f7>" . compile)
 ("<C-f7>" . (lambda()
               (interactive)
               (save-buffer)
               (recompile)))

 :prefix-map buffer-map
 :prefix "C-c b"
 ("i" . ibuffer)
 ("r" . revert-buffer)
 ("s" . save-some-buffers)
 ("S" . crux-sudo-edit)
 ("D" . crux-delete-file-and-buffer)
 ("<f2>" . rename-visited-file)

 :prefix-map file-map
 :prefix "C-c f"
 ("o" . crux-open-with)
 ("s" . save-some-buffers)
 ("S" . crux-sudo-edit)
 ("D" . crux-delete-file-and-buffer)
 ("<f2>" . rename-visited-file)

 :prefix-map search-map
 :prefix "C-c s"
 ("s" . deadgrep)
 ("l" . consult-line)

 :prefix-map mark-map
 :prefix "C-c m"
 ("'" . er/mark-inside-quotes)
 ("[" . er/mark-inside-pairs)
 ("l" . goto-last-change)
 ("m" . bm-toggle)
 ("0" . bm-remove-all-current-buffer)

 :prefix-map code-map
 :prefix "C-c c"
 ("." . consult-lsp-diagnostics)

 ;; :prefix-map lsp-map
 ;; :prefix "C-c l"

 :prefix-map git-mode
 :prefix "C-c v"
 ("d" . magit-dispatch)
 ("t" . git-timemachine)

 :prefix-map remove-map
 :prefix "C-c -"
 ("b" . bookmark-delete)
 ("r" . recentf-edit-list)
 ("p" . project-forget-project)
 )

;; view-mode
(use-package view
  :ensure nil
  :bind (:map view-mode-map
               ("j" . next-line)
               ("k" . previous-line)
               ("h" . backward-char)
               ("l" . forward-char)
               ("g" . goto-line)
               ("b" . View-scroll-page-backward))
  :config
  (setq view-read-only t))

(provide 'ee-keybindings)
;;; keybindings.el ends here
