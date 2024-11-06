;;; ee-shell.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Tramp
(setq tramp-default-method "ssh"
      password-cache-expiry 36000)

;; bash-completion
;; (use-package bash-completion
;;   :defer t
;;   :when (eq system-type 'gnu/linux)
;;   :init
;;   (autoload 'bash-completion-dynamic-complete
;;     "bash-completion"
;;     "BASH completion hook")
;;   (add-hook 'shell-dynamic-complete-functions
;;             'bash-completion-dynamic-complete))

;; exec-path-from-shell
;; (use-package exec-path-from-shell
;;   :defer t
;;   :when (eq system-type 'gnu/linux)
;;   :init
;;   (exec-path-from-shell-initialize))

;; vterm
(use-package vterm
  :defer t
  :when (eq system-type 'gnu/linux)
  :config
  (setq vterm-shell "zsh")
  :bind (:map vterm-mode-map
              ("<f2>" . shell-pop)))

;; shell-pop
(use-package shell-pop
  :bind (("<f2>" . shell-pop))
  :init
  (setq shell-pop-window-size 30
        shell-pop-shell-type
        (cond ((fboundp 'vterm) '("vterm" "*vterm*" #'vterm))
              ((eq system-type 'windows-nt) '("eshell" "*eshell*" #'eshell))
              (t '("terminal" "*terminal*"
                   (lambda () (term shell-pop-term-shell)))))))

(use-package journalctl-mode
  :defer t)

(provide 'ee-shell)
;;; init-shell.el ends here
