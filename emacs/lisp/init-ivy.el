;;; init-ivy.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; amx
(use-package amx
  :config
  (setq amx-save-file (expand-file-name "amx" my-temp)))

;; counsel
(use-package counsel
  :diminish ivy-mode counsel-mode
  :bind ( ("C-s" . swiper)
          ("M-x" . counsel-M-x)
          ("M-y" . counsel-yank-pop)
          ("C-x C-f" . counsel-find-file)
          ("C-x C-r" . counsel-recentf)
          ("C-c r" . counsel-rg)
          ("C-c b" . counsel-bookmark)
          ("C-x 8 i" . counsel-unicode-char)
          ("C-h a" . counsel-apropos)

          ("C-c C-r" . ivy-resume)
          ("C-x b" . ivy-switch-buffer)
          ("C-x C-b" . ivy-switch-buffer)
          ("C-c C-o" . ivy-occur)
         ))

;; ivy
(use-package ivy
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t) ;Add recent files and bookmarks to the ivy-switch-buffer
    (setq ivy-initial-inputs-alist nil) ;Don't use ^ as initial input
    (setq counsel-yank-pop-separator "\n-------\n")
    (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)))

;; ivy-rich
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(provide 'init-ivy)
;;; init-ivy.el ends here