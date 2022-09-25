;;; init-project.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Treemacs
(leaf treemacs
  :ensure t
  :bind (("<f1>" . treemacs)
         (treemacs-mode-map
          ([mouse-1]
           . treemacs-single-click-expand-action))))

;; Magit
(leaf magit
  :ensure t
  :bind
  (("C-c g" . magit-status)
   ("s-g" . magit-status)
   (:magit-status-mode-map
   ("p" . magit-push))))

;; git-gutter
(leaf git-gutter+
  :ensure t
  :blackout
  `((git-gutter+-mode . ,(format "%s" (all-the-icons-octicon "git-merge"))))
  :bind ("C-x G" . global-git-gutter+-mode)
  )

(leaf forge
  :disabled t
  :after magit
  )

;; Dashboard
(leaf dashboard
  :init
  (let ((custom--inhibit-theme-enable nil))
    (unless (memq 'use-package custom-known-themes)
      (deftheme use-package)
      (enable-theme 'use-package)
      (setq custom-enabled-themes (remq 'use-package custom-enabled-themes)))
    (custom-theme-set-variables 'use-package
                                '(dashboard-startup-banner 2 nil nil "Customized with use-package dashboard")
                                '(dashboard-set-heading-icons t nil nil "Customized with use-package dashboard")
                                '(dashboard-set-file-icons t nil nil "Customized with use-package dashboard")
                                '(dashboard-set-footer nil nil nil "Customized with use-package dashboard")
                                '(dashboard-center-content t nil nil "Customized with use-package dashboard")
                                '(dashboard-projects-backend 'project-el nil nil "Customized with use-package dashboard")
                                '(dashboard-items
                                  '((recents . 12)
                                    (bookmarks . 5)
                                    (projects . 5))
                                  nil nil "Customized with use-package dashboard")))
  :require t
  :diminish dashboard-mode page-break-lines-mode
  :config
  (dashboard-setup-startup-hook))
;; (use-package dashboard
;;   :diminish (dashboard-mode page-break-lines-mode)
;;   :custom
;;   (dashboard-startup-banner 2)
;;   (dashboard-set-heading-icons t)
;;   (dashboard-set-file-icons t)
;;   (dashboard-set-footer nil)
;;   (dashboard-center-content t)
;;   (dashboard-projects-backend 'project-el)

;;   (dashboard-items '((recents  . 12)
;;                      (bookmarks . 5)
;;                      (projects . 5)))
;;   :config
;;   (dashboard-setup-startup-hook))



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
