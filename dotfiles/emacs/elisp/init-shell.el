;;; init-shell.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Tramp
(setq tramp-default-method "ssh"
      password-cache-expiry 36000)

;; eshell


;; bash-completion
(leaf bash-completion
  :ensure t
  :when (eq system-type 'gnu/linux)
  :commands bash-completion-dynamic-complete
  :hook ((shell-dynamic-complete-functions . bash-completion-dynamic-complete)))

;; exec-path-from-shell
(leaf exec-path-from-shell
  :ensure t
  :when (eq system-type 'gnu/linux)
  :config
  (exec-path-from-shell-initialize))

;; vterm
(leaf vterm
  :ensure t
  :when (eq system-type 'gnu/linux)
  :setq ((vterm-shell . "zsh"))
  :bind (:vterm-mode-map
         ("<f2>" . shell-pop)))

;; shell-pop
(leaf shell-pop
  :ensure t
  :blackout t
  :bind (("<f2>" . shell-pop))
  :custom ((shell-pop-window-size . 30)
           (shell-pop-full-span . t)
           ;; (shell-pop-universal-key . "<f2>")
           (shell-pop-window-position . "bottom")))
(setq shell-pop-shell-type
      (cond ((fboundp 'vterm) '("vterm" "*vterm*" #'vterm))
            ((eq system-type 'windows-nt) '("eshell" "*eshell*" #'eshell))
            (t '("terminal" "*terminal*"
                 (lambda () (term shell-pop-term-shell))))))

(provide 'init-shell)
;;; init-shell.el ends here
