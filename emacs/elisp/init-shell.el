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
  (leaf bash-completion
    :ensure t
    :commands bash-completion-dynamic-complete
    :hook ((shell-dynamic-complete-functions . bash-completion-dynamic-complete))))

;; exec-path-from-shell
(when (eq system-type 'gnu/linux)
  (leaf exec-path-from-shell
    :ensure t
    :init
    (let ((custom--inhibit-theme-enable nil))
      (unless (memq 'use-package custom-known-themes)
        (deftheme use-package)
        (enable-theme 'use-package)
        (setq custom-enabled-themes (remq 'use-package custom-enabled-themes)))
      (custom-theme-set-variables 'use-package
                                  '(exec-path-from-shell-check-startup-files nil nil nil "Customized with use-package exec-path-from-shell")
                                  '(exec-path-from-shell-variables
                                    '("PATH" "MANPATH" "PYTHONPATH" "GOPATH")
                                    nil nil "Customized with use-package exec-path-from-shell")
                                  '(exec-path-from-shell-arguments
                                    '("-l")
                                    nil nil "Customized with use-package exec-path-from-shell")))
    (exec-path-from-shell-initialize)
    :require t))

;; vterm
(when (eq system-type 'gnu/linux)
  (leaf vterm
    :ensure t
    :config
    (with-eval-after-load 'vterm
      (setq vterm-shell "zsh")
      (define-key vterm-mode-map
                  (kbd "<f2>")
                  'shell-pop))))

;; shell-pop
(leaf shell-pop
  :ensure t
  :bind (([f2]
          . shell-pop))
  :setq ((shell-pop-window-size . 30))
  :config
  (setq shell-pop-shell-type (cond
                              ((fboundp 'vterm)
                               '("vterm" "*vterm*" #'vterm))
                              ((eq system-type 'windows-nt)
                               '("eshell" "*eshell*" #'eshell))
                              (t
                               '("terminal" "*terminal*"
                                 (lambda nil
                                   (term shell-pop-term-shell)))))))

(provide 'init-shell)
;;; init-shell.el ends here
