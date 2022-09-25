;;; init-project.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Treemacs
(leaf treemacs
  :ensure t
  :bind (("<f1>" . treemacs)
         (treemacs-mode-map
          ([mouse-1] . treemacs-single-click-expand-action))))

;; Magit
(leaf magit
  :ensure t
  :bind
  (("C-c g" . magit-status)
   ("s-g" . magit-status)
   (:magit-status-mode-map
   ("p" . magit-push))))

;; git-gutter
(leaf git-gutter
  :ensure t
  :diminish "GITGU"
  :custom (global-git-gutter-mode . t))

(leaf forge
  :disabled t
  :after magit
  )

;; Dashboard
(leaf dashboard
  :ensure t
  :diminish (dashboard-mode page-break-lines-mode)
  :setq ((dashboard-startup-banner . 2)
         (dashboard-set-heading-icons . t)
         (dashboard-set-file-icons . t)
         (dashboard-set-footer . nil)
         (dashboard-center-content . t)
         (dashboard-projects-backend . 'project-el)
         (dashboard-items . '((recents  . 12)
                              (bookmarks . 5)
                              (projects . 5))))
  :config
  (dashboard-setup-startup-hook))

;; Persp-mode
(leaf persp-mode
  :ensure t
  :init
  (setq persp-keymap-prefix (kbd "C-c w"))
  :require t
  :setq ((persp-auto-resume-time . 0))
  :config
  (add-hook 'after-init-hook
            #'(lambda nil
                (persp-mode 1))))

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
