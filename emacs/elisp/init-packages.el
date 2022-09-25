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
(leaf s
  :require t)

;; file manipulation
(leaf f
  :require t)

;; (use-package bind-key)
(leaf diminish
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
(load-theme 'doom-tomorrow-night t)

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

(leaf all-the-icons
  :ensure t
  :require t)

(leaf which-key
  :ensure t
  :require t
  :diminish which-key-mode
  :config
  (which-key-mode))

(leaf helpful
  :ensure t)

(leaf expand-region
  :ensure t
  :require t)

;; mwim ;moving to the beginning/end code
(leaf mwim
  :ensure t
  :require t)

;; move-text M-up/M-down
(leaf move-text
  :ensure t
  :init
  (move-text-default-bindings)
  :require t)

(leaf iedit
  :ensure t)

(leaf multiple-cursors
  :ensure t)

;; Smartly select region, rectangle, multi cursors
(leaf smart-region
  :ensure t
  :commands smart-region-on
  :hook ((after-init-hook . smart-region-on)))

(leaf anzu
  :ensure t
  :require t)

(leaf wgrep
  :ensure t)

(leaf hl-todo
  :ensure t
  :require t
  :config
  (global-hl-todo-mode))

(leaf macrostep
  :ensure t
  :require t)

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
  :hook (after-init-hook)
  :config
  (with-eval-after-load 'fancy-narrow
    (if (fboundp 'diminish)
        (diminish 'fancy-narrow-mode))))

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
  :require t)

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
  :hook (emacs-startup-hook)
  :setq ((gcmh-idle-delay quote auto)
         (gcmh-auto-idle-delay-factor . 10)
         (gcmh-high-cons-threshold . 16777216))
  :config
  (with-eval-after-load 'gcmh
    (if (fboundp 'diminish)
        (diminish 'gcmh-mode))))

(provide 'init-packages)
;;; init-packages.el ends here
