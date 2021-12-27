;;; config.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Environment 环境设定
(when (eq system-type 'gnu/linux)
  ;; (set-fontset-font t 'han (font-spec :family "NotoSansSC" :size 17))
  (setq org-directory "~/Documents/org/"))

;; (when (eq system-type 'windows-nt)
;; ;; (set-fontset-font t 'han (font-spec :family "Microsoft Yahei" :size 17))
;;   (setq default-directory "C:/Users/gecko/Desktop/" ;主目录
;;         org-directory "c:/Users/gecko/Documents/org/"))

;; 字体 fonts
;; Consolas, Hack, Source Code Pro,
;; Microsoft Yahei, NotoSansSC,
(set-face-attribute 'default nil :font "等距更纱黑体 SC-12")
;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;   (set-fontset-font (frame-parameter nil 'font)
;;                     charset
;;                     (font-spec :family "NotoSansSC" :size 16)))

;; Org-table font
(custom-set-faces
 '(org-table ((t (:family "等距更纱黑体 SC")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; Editor ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 界面 interface
(setq inhibit-startup-message t     ;关闭欢迎界面
      inhibit-default-init t
      initial-scratch-message nil
      initial-major-mode 'fundamental-mode
      initial-frame-alist (quote ((fullscreen . maximized))) ;启动最大化
      visible-bell 1                ;关闭错误警示
      system-time-locale "C"        ;使用英文时间格式
      ispell-dictionary "en"        ;使用英文词典
      sentence-end-double-space nil ;Sentences should end in one space
      sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*" ;识别中文标点符号
      save-interprogram-paste-before-kill t ;save system clipboard before emacs clipboard replacing
      confirm-kill-processes nil
      require-final-newline t)

(defun display-startup-echo-area-message ()
  "删除启动讯息"
  (message ""))

;; Modeline
(column-number-mode t)      ;显示列数
(size-indication-mode t)    ;显示文件大小

(show-paren-mode 1)                         ;括号匹配 parens
(electric-pair-mode t)                      ;自动补全括号
(delete-selection-mode t)                   ;overwrite selected text
(global-visual-line-mode 1)                 ;折叠 word wrap
(global-prettify-symbols-mode 1)            ;Show lambda as λ.
(fset 'yes-or-no-p 'y-or-n-p)
(setq-default frame-title-format "%b (%f)") ;标题栏显示正在编辑的文件名
(ffap-bindings)                             ;find-file-at-point, smarter C-x C-f when point on path or URL

;; 鼠标 Mouse & Smooth Scroll
;; Scroll one line at a time (less "jumpy" than defaults)
(when (display-graphic-p)
  (setq mouse-wheel-scroll-amount '(1 ((shift) . hscroll))
        mouse-wheel-scroll-amount-horizontal 1
        mouse-wheel-progressive-speed nil))
(setq scroll-step 1
      scroll-margin 0
      scroll-conservatively 100000
      auto-window-vscroll nil
      scroll-preserve-screen-position t)
(blink-cursor-mode -1)               ;禁用指针闪烁
(setq mouse-yank-at-point t)         ;禁用鼠标点击粘贴
(global-unset-key (kbd "<mouse-2>")) ;禁用鼠标中键
(fset 'mouse-save-then-kill 'ignore) ;禁用鼠标右键双击剪切

;; 编码 encoding, last is highest priority.
;; (prefer-coding-system 'cp950)
;; (prefer-coding-system 'gb2312)
;; (prefer-coding-system 'cp936)
;; (prefer-coding-system 'gb18030)
;; (prefer-coding-system 'utf-16)
;; (prefer-coding-system 'utf-8-dos)
;; (prefer-coding-system 'utf-8-unix)

;; Tab and Space
(setq-default c-basic-offset   4
              tab-width        4
              indent-tabs-mode nil ;indent with spaces, never with TABs
              tab-always-indent 'complete) ;Tab key indent first then completion.

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
;; (setq auto-save-visited-interval 15) ;default is 5s
;; (auto-save-visited-mode 1)

;; 失去焦点时保存
(defun save-all ()
  (interactive)
  (save-some-buffers t))
(add-hook 'focus-out-hook 'save-all)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Built-in ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
        "^/tmp/" "\\.?ido\\.last$" "\\.revive$" "/TAGS$"
        ".recentf" "emacs_backup" "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\)$"))
(recentf-mode 1)

;; Dired
(put 'dired-find-alternate-file 'disabled nil) ;a键进入目录时只用一个buffer
(setq dired-recursive-copies 'always           ;递归操作目录
      dired-recursive-deletes 'top             ;询问一次;
      dired-listing-switches "-lha "           ;human-readable listing
      )
;; auto refresh dired when file changes
(add-hook 'dired-mode-hook 'auto-revert-mode)
(require 'dired-x)

;; ibuffer
(defalias 'list-buffers 'ibuffer)
(setq ibuffer-expert t) ; 直接操作不询问
(setq ibuffer-use-other-window t)

;; winner C-c ←/→ undo/redo window
(winner-mode 1)

;; whitespace
(setq whitespace-action '(auto-cleanup)  ;automatically clean up bad whitespace
      whitespace-style '(face
                         trailing space-before-tab
                         indentation empty space-after-tab))
(whitespace-mode 1)

;; pulse 滚动焦点闪烁
(defun pulse-line (&rest _)
      "Pulse the current line."
      (pulse-momentary-highlight-one-line (point)))

(dolist (command '(scroll-up-command scroll-down-command
                   recenter-top-bottom other-window))
  (advice-add command :after #'pulse-line))

;; narrow 命令跳过初始化提醒
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)
;; enabled change region case commands
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
;; enable erase-buffer command
(put 'erase-buffer 'disabled nil)

;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev                 ;搜索当前 buffer, expand word "dynamically"
        try-expand-dabbrev-all-buffers     ;搜索所有 buffer
        try-expand-dabbrev-from-kill       ;从 kill-ring 中搜索
        try-complete-file-name-partially   ;文件名部分匹配
        try-complete-file-name             ;文件名匹配
        try-expand-all-abbrevs             ;匹配所有缩写词, according to all abbrev tables
        try-expand-list                    ;补全一个列表
        try-expand-line                    ;补全当前行
        try-complete-lisp-symbol-partially ;部分补全 lisp symbol
        try-complete-lisp-symbol))         ;补全 lisp symbol

;; Tramp
(setq tramp-default-method "ssh"
      password-cache-expiry 36000 ;config for caching password for 36000s
      )

;; eshell

;; flyspell
(require 'flyspell)
(setq ispell-program-name "aspell" ; use aspell instead of ispell
      ispell-extra-args '("--sug-mode=ultra"))



(provide 'config)
;;; config.el ends here
