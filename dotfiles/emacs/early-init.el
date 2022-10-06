;;; early-init.el --- -*- lexical-binding: t -*-

;; Defer garbage collection further back in the startup process
(setq gc-cons-threshold most-positive-fixnum)

;; Prevent unwanted runtime compilation for gccemacs (native-comp) users;
;; packages are compiled ahead-of-time when they are installed and site files
;; are compiled when gccemacs is installed.
(setq native-comp-deferred-compilation nil)

;; Package initialize occurs automatically, before `user-init-file' is
;; loaded, but after `early-init-file'. We handle package
;; initialization, so we must prevent Emacs from doing it early!
(setq package-enable-at-startup nil)

;; In noninteractive sessions, prioritize non-byte-compiled source files to
;; prevent the use of stale byte-code. Otherwise, it saves us a little IO time
;; to skip the mtime checks on every *.elc file.
(setq load-prefer-newer noninteractive)

;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t)

;; Faster to disable these here (before they've been initialized)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(push '(menu-bar-lines       . nil) default-frame-alist)
(push '(tool-bar-lines       . nil) default-frame-alist)
(push '(alpha-background     . 98 ) default-frame-alist)
;; (push '(scroll-bar-mode      . nil) default-frame-alist)
;; (push '(blink-cursor-mode    . nil) default-frame-alist)
;; (push '(column-number-mode   . nil) default-frame-alist)

;; Disable GUI elements
(add-hook 'before-make-frame-hook
          #'(lambda ()
              (setq inhibit-splash-screen t)
              (setq use-file-dialog nil)
              (setq initial-frame-alist (quote ((fullscreen . maximized))))
              ;; (setq default-frame-alist
              ;;       '((height . 48)
              ;;         (width . 83)))
              ))

(setq frame-inhibit-implied-resize t)
(setq site-run-file nil)

(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors nil
        native-comp-deferred-compilation t))

(provide 'early-init)
;;; early-init.el ends here
