;;; init-project.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Treemacs
(use-package treemacs
  :defer t
  :bind (("<f1>" . treemacs)
         :map treemacs-mode-map
         ([mouse-1] . treemacs-single-click-expand-action)))

;; Magit
(use-package magit
  :defer t
  :if (executable-find "git")
  :config
  (setq magit-completing-read-function 'ivy-completing-read)
  :bind (("C-c g" . magit-status)
         ("s-g" . magit-status)
         :map magit-status-mode-map
         ("p" . magit-push)))

;; Dashboard
(use-package dashboard
  :diminish (dashboard-mode page-break-lines-mode)
  :custom
  (dashboard-startup-banner 2)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-set-footer nil)
  (dashboard-center-content t)
  (dashboard-projects-backend 'project-el)

  (dashboard-items '((recents  . 12)
                     (bookmarks . 5)
                     (projects . 5)))
  :config
  (dashboard-setup-startup-hook))

;; Persp-mode
(use-package persp-mode
  :config
  ;; (setq wg-morph-on nil) ;; switch off animation
  (setq persp-auto-resume-time 0)
  (add-hook 'after-init-hook #'(lambda () (persp-mode 1)))

  ;; (setq persp-nil-name "home")
  )

;; Projectile
;; (use-package projectile
;;   :diminish projectile-mode
;;   :commands projectile-mode
;;   ;; :bind-keymap ("s-p" . projectile-command-map)
;;   :init (setq projectile-require-project-root nil) ; make projectile usable for every directory
;;   :config
;;   (progn
;;     (projectile-mode 1)
;;     (setq projectile-completion-system 'ivy)
;;     (setq projectile-switch-project-action #'projectile-dired)))

(provide 'init-project)
;;; init-project.el ends here
