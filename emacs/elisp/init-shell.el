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
(leaf exec-path-from-shell
  :ensure t
  :when (and window-system (not (eq system-type 'gnu/linux)))
  :defun exec-path-from-shell-initialize
  :config (exec-path-from-shell-initialize))

;; vterm
(when (eq system-type 'gnu/linux)
  (leaf vterm
    :ensure t
    :setq ((vterm-shell . "zsh"))
    :bind (:vterm-mode-map
           ("<f2>" . shell-pop))))

;; shell-pop
(leaf shell-pop
  :ensure t
  :bind (([f2] . shell-pop))
  :setq ((shell-pop-window-size . 30)
         (shell-pop-shell-type . "vterm")
         ))

(provide 'init-shell)
;;; init-shell.el ends here
