;;; init-dired.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; all-the-icons-dired
(use-package all-the-icons-dired
  :config
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; Dired
(put 'dired-find-alternate-file 'disabled nil) ;a键进入目录时只用一个buffer
(setq dired-recursive-copies 'always           ;递归操作目录
      dired-recursive-deletes 'top             ;询问一次;
      dired-listing-switches "-lha --group-directories-first"
      )
;; auto refresh dired when file changes
(add-hook 'dired-mode-hook 'auto-revert-mode)
(require 'dired-x)

;; key bindings
(define-key dired-mode-map "f" 'counsel-find-file)
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
(define-key dired-mode-map "." 'dired-hide-details-mode)
(define-key dired-mode-map "/" 'funs/dired-filter-show-match)
(define-key dired-mode-map "b"
  (lambda ()
    (interactive)
    (find-alternate-file "..")))
;;;###autoload
(defun funs/dired-filter-show-match ()
  "Only show filter file."
  (interactive)
  (call-interactively #'dired-mark-files-regexp)
  (command-execute "tk"))


(provide 'init-dired)
;;; init-dired.el ends here
