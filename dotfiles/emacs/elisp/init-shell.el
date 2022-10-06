;;; init-shell.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Tramp
(setq tramp-default-method "ssh"
      password-cache-expiry 36000)

;; eshell


;; bash-completion
(when (eq system-type 'gnu/linux)
  (leaf bash-completion
    :ensure t
    :commands bash-completion-dynamic-complete
    :hook ((shell-dynamic-complete-functions . bash-completion-dynamic-complete))))

;; exec-path-from-shell

;; vterm
(when (eq system-type 'gnu/linux)
  (leaf vterm
    :ensure t
    :setq ((vterm-shell . "zsh"))
    :bind (:vterm-mode-map
           ("<f2>" . shell-pop))
    ))

;; shell-pop
(leaf shell-pop
  :ensure t
  :blackout t
  :bind (("<f2>" . shell-pop))
  :custom ((shell-pop-shell-type . '("shell" "*shell*" (lambda () (vterm))))
           ;; (shell-pop-universal-key . "<f2>")
           (shell-pop-window-size . 30)
           (shell-pop-full-span . t)
           (shell-pop-window-position . "bottom")))

(provide 'init-shell)
;;; init-shell.el ends here
