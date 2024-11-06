;;; ee-backup.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;save system clipboard before emacs clipboard
(setq save-interprogram-paste-before-kill t)

;; 备份 Backup
(global-auto-revert-mode 1)        ;自动加载被外部修改过的文件
(setq backup-directory-alist `((".*" . ,my-backup)))
(setq make-backup-files t          ;备份文件 backup~
      auto-save-default nil        ;stop creating #autosave# files
      create-lockfiles nil         ;stop creating .#lockfile# files 多人编辑中
      delete-by-moving-to-trash t) ;删除至回收站
(setq backup-by-copying t          ; don't clobber symlinks
      kept-new-versions 10         ; keep 10 latest versions
      kept-old-versions 0          ; don't bother with old versions
      delete-old-versions t        ; don't ask about deleting old versions
      version-control t            ; number backups
      vc-make-backup-files t)      ; backup version controlled files


;; 自动保存 autosave
(auto-save-visited-mode 1)
;; (setq auto-save-visited-interval 15) ;default is 5s
(add-function :after after-focus-change-function (lambda () (save-some-buffers t)))

;; save-place 记住光标所在位置
(setq save-place-file (expand-file-name "saveplace" my-temp))
(save-place-mode 1)

;; savehist
(setq savehist-file (expand-file-name "savehist" my-temp)
      savehist-save-minibuffer-history t
      savehist-autosave-interval 60
      savehist-additional-variables '(kill-ring
                                      search-ring
                                      regexp-search-ring))
(savehist-mode 1)

;; bookmarks
(setq bookmark-default-file (expand-file-name "bookmarks" my-temp)
      bookmark-save-flag 1              ;automatically save when changed
      )

;; recentf
(setq recentf-auto-cleanup 'never ;disable before we start recentf!
      recentf-max-saved-items 50
      recentf-max-menu-items 15
      recentf-save-file (expand-file-name "recentf" my-temp)
      recentf-exclude
      '("COMMIT" "autoloads" "archive-contents" "eld" "elpa" "bookmarks" "session"
        "^/tmp/" "\\.?ido\\.last$" "\\.revive$" "/TAGS$" ".cache" "persp-auto-save"
        ".recentf" "emacs_backup" "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\)$"))
(recentf-mode 1)



;; undo-fu
(use-package undo-fu)

;; undo-fu-session
(use-package undo-fu-session
  :custom
  (undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  :config
  (global-undo-fu-session-mode 1))

;; undo-tree C-x u
(use-package vundo
  :bind (("C-x u" . vundo))
  :config
  (setq vundo-glyph-alist vundo-unicode-symbols)
  (setq vundo-roll-back-on-quit nil))


(provide 'ee-backup)
;;; init-backup.el ends here
