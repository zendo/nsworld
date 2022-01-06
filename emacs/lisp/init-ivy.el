;;; init-ivy.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; amx
(use-package amx
  :config
  (setq amx-save-file (expand-file-name "amx" my-temp)))

;; all-the-icons-ivy-rich
(use-package all-the-icons-ivy-rich
  :init (all-the-icons-ivy-rich-mode 1))

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
(global-set-key [remap find-file-read-only-other-window] 'counsel-switch-buffer-other-window)

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


;;----------------------------------------------------------------------------
;; Pop until marker actually moves
;;----------------------------------------------------------------------------
;;;###autoload
(defun modi/multi-pop-to-mark (orig-fun &rest args)
  "Call ORIG-FUN until the cursor moves.Try the repeated popping up to 10 times."
  (let ((p (point)))
    (dotimes (i 10)
      (when (= p (point))
        (apply orig-fun args)))))
(advice-add 'pop-to-mark-command :around
            #'modi/multi-pop-to-mark)

(global-set-key (kbd "M-m") 'pop-to-mark-command)


(provide 'init-ivy)
;;; init-ivy.el ends here
