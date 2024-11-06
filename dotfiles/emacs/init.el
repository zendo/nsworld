;;; ~/.emacs.d/init.el --- Initialize -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Defer garbage collection further back in the startup process
(setq gc-cons-threshold most-positive-fixnum)

;; Prevent flash of unstyled modeline at startup
(setq-default mode-line-format nil)

;; Don't pass case-insensitive to `auto-mode-alist'
(setq auto-mode-case-fold nil)


(unless (or (daemonp) noninteractive init-file-debug)
  ;; Suppress file handlers operations at startup
  ;; `file-name-handler-alist' is consulted on each call to `require' and `load'
  (let ((old-value file-name-handler-alist))
    (setq file-name-handler-alist nil)
    (set-default-toplevel-value 'file-name-handler-alist file-name-handler-alist)
    (add-hook 'emacs-startup-hook
              (lambda ()
                "Recover file name handlers."
                (setq file-name-handler-alist
                      (delete-dups (append file-name-handler-alist old-value))))
              101)))

;; Load path
;; Optimize: Force "lisp"" and "site-lisp" at the head to reduce the startup time.
(defun update-load-path (&rest _)
  "Update `load-path'."
   (push (expand-file-name "elisp" user-emacs-directory) load-path))

;; (defun add-subdirs-to-load-path (&rest _)
;;   "Add subdirectories to `load-path'.
;; Don't put large files in `site-lisp' directory, e.g. EAF.
;; Otherwise the startup will be very slow. "
;;   (let ((default-directory (expand-file-name "site-lisp" user-emacs-directory)))
;;     (normal-top-level-add-subdirs-to-load-path)))

(advice-add #'package-initialize :after #'update-load-path)
;; (advice-add #'package-initialize :after #'add-subdirs-to-load-path)

(update-load-path)
;; Above stolen from: https://github.com/seagle0128/.emacs.d



;; Load Path ;; My version
;; (defvar my-dir (concat user-emacs-directory "elisp"))
;; (add-to-list 'load-path my-dir)
;; (add-to-list 'load-path (expand-file-name "elisp" user-emacs-directory))
;; (push (expand-file-name "elisp" user-emacs-directory) load-path)

;; Backup files
(defconst my-backup (expand-file-name "my-backup" user-emacs-directory))
(unless (file-exists-p my-backup)
  (make-directory my-backup))

;; Temp files (save-place, recenf, undo-tree)
(defconst my-temp (expand-file-name "my-temp" user-emacs-directory))
(unless (file-exists-p my-temp)
  (make-directory my-temp))

;; Split emacs auto customizations
(setq custom-file (expand-file-name ".custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file 'noerror))


(require 'ee-packages)
(require 'ee-common)
(require 'ee-functions)

(require 'ee-backup)
(require 'ee-dired)
(require 'ee-shell)
(require 'ee-minibuffer)
(require 'ee-project)
(require 'ee-keybindings)

(require 'ee-prog)
(require 'ee-lsp)
(require 'ee-org)
(require 'ee-nix)
;; (require 'ee-web)
(require 'ee-c-cpp-java)

;;; init.el ends here
