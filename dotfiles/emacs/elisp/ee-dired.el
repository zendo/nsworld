;;; init-dired.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package diredfl
  :config
  (diredfl-global-mode 1))

(use-package dired-git-info
  :config (setq dgi-auto-hide-details-p nil)
  :hook (dired-after-readin . dired-git-info-auto-enable))

(use-package dired-x
  :ensure nil)

(use-package dired
  :ensure nil
  :custom ((dired-recursive-copies 'always) ;递归操作目录
           (dired-recursive-deletes 'top) ;询问一次;
           (dired-auto-revert-buffer t)
           (dired-listing-switches "-lha --group-directories-first"))
  :bind (("s-d" . dired-jump)
         ("C-x C-d" . dired-jump)
         :map dired-mode-map
         ("f" . consult-find)
         ("RET" . dired-find-alternate-file)
         ("." . dired-do-print)
         ("," . dired-hide-details-mode)
         ("/" . funs/dired-filter-show-match)
         ("b" . (lambda ()
                  (interactive)
                  (find-alternate-file ".."))))
  :config
  (put 'dired-find-alternate-file 'disabled nil) ;a键进入目录时只用一个buffe
  ;;;###autoload
  (define-advice dired-do-print (:override (&optional _))
    "Show/hide dotfiles."
    (interactive)
    (if (or (not (boundp 'dired-dotfiles-show-p)) dired-dotfiles-show-p)
        (progn
          (setq-local dired-dotfiles-show-p nil)
          (dired-mark-files-regexp "^\\.")
          (dired-do-kill-lines))
      (revert-buffer)
      (setq-local dired-dotfiles-show-p t)))
  ;;;###autoload
  (defun funs/dired-filter-show-match ()
    "Only show filter file."
    (interactive)
    (call-interactively #'dired-mark-files-regexp)
    (command-execute "tk")))

(provide 'ee-dired)
;;; init-dired.el ends here
