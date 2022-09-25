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


(require 'cl-lib)

;; (use-package dash)
(use-package s) ;string manipulation
(use-package f) ;file manipulation

(use-package bind-key)
(use-package diminish)
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

(leaf tangonov-theme
  :ensure t
  :require t)

;; (use-package monokai-theme)
;; (use-package vscode-dark-plus-theme)
;; (use-package zenburn)
;; (use-package eclipse-theme)
(load-theme 'doom-tomorrow-night t)

(leaf all-the-icons
  :ensure t
  :require t)

;; Which-Key
(leaf which-key
  :ensure t
  :require t
  :diminish which-key-mode
  :config
  (which-key-mode))

;; Helpful
(leaf helpful
  :ensure t)

;; expand-region
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

;; iedit
(leaf iedit
  :ensure t)

;; multiple-cursors
(leaf multiple-cursors
  :ensure t)

;; Smartly select region, rectangle, multi cursors
(leaf smart-region
  :ensure t
  :commands smart-region-on
  :hook ((after-init-hook . smart-region-on)))

;; anzu
(leaf anzu
  :ensure t
  :require t)

;; wgrep
(leaf wgrep
  :ensure t)

;; hl-todo
(leaf hl-todo
  :ensure t
  :require t
  :config
  (global-hl-todo-mode))

;; macrostep
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

;; olivetti 文档居中
(leaf olivetti
  :ensure t
  :commands olivetti-mode
  :config
  (with-eval-after-load 'olivetti
    (setq olivetti-body-width 100)
    (setq olivetti-hide-mode-line t)))

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
