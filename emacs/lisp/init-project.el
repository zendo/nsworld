;;; init-project.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; dired-sidebar
;; (use-package dired-sidebar
;;   :defer t
;;   :bind (([f1] . dired-sidebar-toggle-sidebar))
;;   :init
;;   (add-hook 'dired-sidebar-mode-hook
;;             (lambda ()
;;               (unless (file-remote-p default-directory)
;;                 (auto-revert-mode))))
;;   :config
;;   (setq dired-sidebar-use-term-integration t)
;;   (setq dired-sidebar-theme 'icons))

;; treemacs
(use-package treemacs
  :defer t
  :bind (([f1]        . treemacs)
         ("M-0"       . treemacs-select-window)
         :map treemacs-mode-map
         ([mouse-1]   . treemacs-single-click-expand-action))
  :config
  ;; (setq treemacs-no-png-images t) ; tui
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always))

;; treemacs-all-the-icons
(use-package treemacs-all-the-icons
  :after (treemacs)
  :config (treemacs-load-theme "all-the-icons"))

;; ibuffer-sidebar
(use-package ibuffer-sidebar
  :defer t)

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :commands projectile-mode
  :bind-keymap ("C-c p" . projectile-command-map)
  :init (setq projectile-require-project-root nil) ; make projectile usable for every directory
  :config
  (progn
    (projectile-mode 1)
    (setq projectile-completion-system 'ivy)
    (setq projectile-switch-project-action #'projectile-dired)))

;; dashboard
(use-package dashboard
  :diminish (dashboard-mode page-break-lines-mode)
  :custom
  (dashboard-startup-banner 2)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-set-footer nil)
  (dashboard-center-content t)

  (dashboard-items '((recents  . 12)
                     (bookmarks . 5)
                     (projects . 5)))
  :config
  (dashboard-setup-startup-hook))
;; emacsclient open dashboard
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))


;; Magit
(use-package magit
  :defer t
  :if (executable-find "git")
  :config
  (setq magit-completing-read-function 'ivy-completing-read)
  :bind (
         ("C-x g" . magit-status)
         ("C-c g s" . magit-status)
         ("C-c g d" . magit-dispatch)
         ("C-c g x" . magit-checkout)
         ("C-c g c" . magit-commit)
         ("C-c g p" . magit-push)
         ("C-c g u" . magit-pull)
         ("C-c g e" . magit-ediff-resolve)
         ("C-c g r" . magit-rebase-interactive)
         ("C-c g f" . magit-format-patch)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; Functions ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dashboard
 (defun open-dashboard ()
      "Open the *dashboard* buffer and jump to the first widget."
      (interactive)
      ;; Check if need to recover layout
      (if (> (length (window-list-1))
             ;; exclude `treemacs' window
             (if (and (fboundp 'treemacs-current-visibility)
                      (eq (treemacs-current-visibility) 'visible))
                 2
               1))
          (setq dashboard-recover-layout-p t))

      (delete-other-windows)

      ;; Refresh dashboard buffer
      (when (get-buffer dashboard-buffer-name)
        (kill-buffer dashboard-buffer-name))
      (dashboard-insert-startupify-lists)
      (switch-to-buffer dashboard-buffer-name)

      ;; Jump to the first section
      (dashboard-goto-recent-files))

    (defun dashboard-goto-recent-files ()
      "Go to recent files."
      (interactive)
      (let ((func (local-key-binding "r")))
        (and func (funcall func))))


(provide 'init-project)
;;; init-project.el ends here
