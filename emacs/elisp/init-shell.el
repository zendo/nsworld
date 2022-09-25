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
  :config
  (setq exec-path-from-shell-check-startup-files nil
        exec-path-from-shell-arguments nil
        exec-path-from-shell-variables '("DEBEMAIL"
                                         "DEBFULLNAME"
                                         "GPG_AGENT_INFO"
                                         "GPG_KEY_ID"
                                         "PASSWORD_STORE_DIR"
                                         "PATH"
                                         "SHELL"
                                         "SKKSERVER"
                                         "TEXMFHOME"
                                         "GOPATH"
                                         "PYTHONPATH"
                                         "WSL_DISTRO_NAME"
                                         "http_proxy"))))

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
