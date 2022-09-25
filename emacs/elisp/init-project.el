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
  :config
  (when (executable-find "git")
    (unless (fboundp 'magit-status)
      (autoload #'magit-status "magit" nil t))
    (unless (fboundp 'magit-push)
      (autoload #'magit-push "magit" nil t))
    (eval-after-load 'magit
      '(progn
         (setq magit-completing-read-function 'ivy-completing-read)
         t))

    (bind-keys :package magit
               ("C-c g" . magit-status)
               ("s-g" . magit-status)
               :map magit-status-mode-map
               ("p" . magit-push))))

;; Dashboard
(leaf dashboard
  :ensure t
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
