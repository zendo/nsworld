;;; ~/.emacs.d/init.el --- Initialize -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Speed up startup
(setq auto-mode-case-fold nil)

(unless (or (daemonp) noninteractive)
  (let ((old-file-name-handler-alist file-name-handler-alist))
    ;; If `file-name-handler-alist' is nil, no 256 colors in TUI
    ;; @see https://emacs-china.org/t/spacemacs-centaur-emacs/3802/839
    (setq file-name-handler-alist
          (unless (display-graphic-p)
            '(("\\(?:\\.tzst\\|\\.zst\\|\\.dz\\|\\.txz\\|\\.xz\\|\\.lzma\\|\\.lz\\|\\.g?z\\|\\.\\(?:tgz\\|svgz\\|sifz\\)\\|\\.tbz2?\\|\\.bz2\\|\\.Z\\)\\(?:~\\|\\.~[-[:alnum:]:#@^._]+\\(?:~[[:digit:]]+\\)?~\\)?\\'" . jka-compr-handler))))
    (add-hook 'emacs-startup-hook
              (lambda ()
                "Recover file name handlers."
                (setq file-name-handler-alist
                      (delete-dups (append file-name-handler-alist
                                           old-file-name-handler-alist)))))))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)
(add-hook 'emacs-startup-hook
          (lambda ()
            "Recover GC values after startup."
            (setq gc-cons-threshold 800000
                  gc-cons-percentage 0.1)))

;; In noninteractive sessions, prioritize non-byte-compiled source files to
;; prevent the use of stale byte-code. Otherwise, it saves us a little IO time
;; to skip the mtime checks on every *.elc file.
(setq load-prefer-newer noninteractive)


;; Load Path
(defvar my-dir (concat user-emacs-directory "lisp"))
(add-to-list 'load-path my-dir)
;;(add-to-list 'load-path (expand-file-name "conf" user-emacs-directory))

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
;; (when (file-exists-p custom-file)
;;   (load custom-file 'noerror))


(require 'config)
(require 'packages)
(require 'functions)
(require 'lang-main)
(require 'lang-org)
;; (require 'lang-c-cpp-java)
;; (require 'lang-web)
(require 'init-dired)
;; (require 'init-selectrum)
(require 'init-ivy)
;; (require 'init-meow)
(require 'keybindings)


;;; init.el ends here
