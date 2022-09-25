;;; init-packages.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>

;; Now you can use leaf!
(leaf leaf-tree :ensure t)
(leaf leaf-convert :ensure t)

;; (leaf feather
;;   :el-get conao3/feather.el
;;   :config (feather-mode))


(eval-when-compile (require 'cl-lib nil t))

;; string manipulation
;; (leaf s
;;   :ensure t
;;   :require t)

;; ;; file manipulation
;; (leaf f
;;   :ensure t
;;   :require t)

;; (use-package bind-key)
(leaf diminish
  :ensure t
  :require t)

(diminish 'visual-line-mode)
(diminish 'eldoc-mode) ;echo area 显示函数的参数列表

;; Control use of local variables in files you visit.
;; :safe means set the safe variables, and ignore the rest.
(setq enable-local-variables :safe)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Extensions ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme
(leaf doom-themes
  :ensure t
  :require t)
;; (leaf tangonov-theme
;;   :ensure t
;;   :require t)
;; (leaf monokai-theme
;;   :require t)
;; (leaf vscode-dark-plus-theme
;;   :require t)
;; (leaf zenburn
;;   :require t)
;; (leaf eclipse-theme
;;   :require t)
(load-theme 'doom-tomorrow-night t)

(leaf all-the-icons
  :ensure t
  :require t)

(leaf which-key
  :ensure t
  :diminish which-key-mode
  :hook (after-init-hook . which-key-mode))

(leaf helpful
  :ensure t
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)))

(leaf expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)
         ("C--" . er/contract-region)))

;; mwim ;moving to the beginning/end code
(leaf mwim
  :ensure t
  :require t
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)))

;; move-text M-up/M-down
(leaf move-text
  :ensure t
  :init
  (move-text-default-bindings)
  :require t)

(leaf iedit
  :ensure t)

(leaf multiple-cursors
  :ensure t
  :bind (("C-}" . mc/mark-next-like-this)
         ("C-{" . mc/mark-previous-like-this)
         ("C-|" . mc/mark-all-like-this-dwim)))

;; Smartly select region, rectangle, multi cursors
(leaf smart-region
  :ensure t
  :commands smart-region-on
  :hook ((after-init-hook . smart-region-on)))

(leaf anzu
  :ensure t
  :bind (([remap query-replace] . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp)))

(leaf wgrep
  :ensure t)

(leaf hl-todo
  :ensure t
  :config
  (global-hl-todo-mode))

;; 高亮删除插入操作
;; (leaf volatile-highlights
;;   :ensure t
;;   :config (volatile-highlights-mode t))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

;; rainbow 颜色代码显色 #00FF00
(leaf rainbow-mode
  :ensure t
  :commands rainbow-mode)

;; rainbow-delimiters  彩虹括号
(leaf rainbow-delimiters
  :ensure t
  :hook (prog-mode-hook))

;; Narrow/Widen
(leaf fancy-narrow
  :ensure t
  :diminish fancy-narrow-mode
  :init
  (fancy-narrow-mode 1))

;; avy
(leaf avy
  :ensure t
  :require t)

;; avy-zap
(leaf avy-zap
  :ensure t
  :require t)

;; ace-window
(leaf ace-window
  :ensure t
  :require t)

;; rotate
(leaf rotate
  :ensure t
  :require t)

;; fanyi
(leaf fanyi
  :ensure t
  :require t
  :bind (("C-c y" . fanyi-dwim2)))

;; doom-modeline
(leaf doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  :require t
  :setq ((doom-modeline-buffer-file-name-style quote relative-to-project)))

;; Garbage Collector Magic Hack
(leaf gcmh
  :ensure t
  :diminish gcmh-mode
  :hook (emacs-startup-hook)
  :setq ((gcmh-idle-delay quote auto)
         (gcmh-auto-idle-delay-factor . 10)
         (gcmh-high-cons-threshold . 16777216)))

(provide 'init-packages)
;;; init-packages.el ends here
