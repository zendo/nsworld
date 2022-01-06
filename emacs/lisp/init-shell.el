;;; init-shell.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Tramp
(setq tramp-default-method "ssh"
      password-cache-expiry 36000 ;config for caching password for 36000s
      )

;; eshell



;; bash-completion
(when (eq system-type 'gnu/linux)
  (use-package bash-completion
    :defer t
    :init
    (autoload 'bash-completion-dynamic-complete
      "bash-completion"
      "BASH completion hook")
    (add-hook 'shell-dynamic-complete-functions
              'bash-completion-dynamic-complete)))

;; exec-path-from-shell
(when (eq system-type 'gnu/linux)
  (use-package exec-path-from-shell
    :custom
    (exec-path-from-shell-check-startup-files nil)
    (exec-path-from-shell-variables '("PATH" "MANPATH" "PYTHONPATH" "GOPATH"))
    (exec-path-from-shell-arguments '("-l"))
    :init
    (exec-path-from-shell-initialize)))

;; vterm
(use-package vterm
  :defer t
  :config
  (setq vterm-shell "zsh")
  (define-key vterm-mode-map (kbd "<f9>")  'shell-pop))

;; shell-pop
(use-package shell-pop
  :defer t
  :bind ([f9] . shell-pop)
  :init
  (setq shell-pop-window-size 30
        shell-pop-shell-type
        (cond ((fboundp 'vterm) '("vterm" "*vterm*" #'vterm))
              ((eq system-type 'windows-nt) '("eshell" "*eshell*" #'eshell))
              (t '("terminal" "*terminal*"
                   (lambda () (term shell-pop-term-shell)))))))

(provide 'init-shell)
;;; lang-main.el ends here
