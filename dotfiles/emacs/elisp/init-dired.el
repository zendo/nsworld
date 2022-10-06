;;; init-dired.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; all-the-icons-dired
(leaf all-the-icons-dired
  :require t
  :ensure t
  :hook (dired-mode-hook))

(leaf diredfl
  :require t
  :ensure t
  :config
  (diredfl-global-mode 1))

(leaf dired-x)

(leaf dired
  :custom ((dired-recursive-copies . 'always) ;递归操作目录
           (dired-recursive-deletes . 'top) ;询问一次;
           (dired-auto-revert-buffer . t)
           (dired-listing-switches . "-lha --group-directories-first"))
  :bind (:dired-mode-map
         ("f" . consult-find)
         ("RET" . dired-find-alternate-file)
         ("." . dired-hide-details-mode)
         ("/" . funs/dired-filter-show-match)
         ("b" . (lambda ()
                  (interactive)
                  (find-alternate-file "..")))))
;;;###autoload
(defun funs/dired-filter-show-match ()
  "Only show filter file."
  (interactive)
  (call-interactively #'dired-mark-files-regexp)
  (command-execute "tk"))

(put 'dired-find-alternate-file 'disabled nil) ;a键进入目录时只用一个buffer

(provide 'init-dired)
;;; init-dired.el ends here
